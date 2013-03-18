module Babelicious

  class HashMap < BaseMap
    attr_accessor :path_translator

    class << self
      
      def initial_target
        {}
      end
      
      def filter_source(source)
        source
      end
      
    end

    def initialize(path_translator, opts={})
      @path_translator, @opts = path_translator, opts
    end
    
    def value_from(source)
      hash = {}
      element = ""
      return source if (@path_translator.full_path == "" || @path_translator.full_path == "/")
      @path_translator.inject_with_index(hash) do |hsh, element, index|
        return source_element(hsh, element) if (index == @path_translator.last_index && index != 0)
        if hsh.empty?
          source_element(source, element)
        else 
          source_element(hsh, element)
        end
      end
    end

    protected

    def map_output(hash_output, source_value)
      catch :no_value do
        @path_translator.inject_with_index(hash_output) do |hsh, element, index|
          if(hsh[element])
            hsh[element]
          else
            hsh[element] = (index == @path_translator.last_index ? map_source_value(source_value) : {})
          end 
        end
      end 
    end 

    private
    
    def source_element(source, element)
      source[element.to_sym] || source[element.to_s] || ''
    rescue TypeError => e
      # This method deals with `source` being a string by abusing a strange
      # behavior in ruby 1.8.7. Namely that `""[:foo] => nil` and `""["foo"]
      # => nil`. So in ruby 1.8.7 when a string is passed for the source
      # parameter, the first two checks will yield nil, and the result will be
      # the empty string. In ruby 1.9.3, however, `""[:foo]` raises a
      # TypeError.
      if /can't convert Symbol into Integer/ === e.message
        ""
      else
        raise e
      end
    end
    
    def map_source_value(source_value)
      if(@customized_map)
        @customized_map.call(source_value)
      else 
        source_value
      end 
    end

  end
end
