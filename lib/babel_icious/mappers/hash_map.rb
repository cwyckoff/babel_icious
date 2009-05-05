module Babelicious

  class HashMap < BaseMap
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
      @path_translator.inject_with_index(hash) do |hsh, element, index|
        return hsh[element.to_sym] if (index == @path_translator.last_index && index != 0)
        if hsh.empty?
          source_element(source, element)
        else 
          hsh[element.to_sym]
        end
      end
    end

    private
    
    def source_element(source, element)
      source[element.to_sym] || source[element.to_s]
    end

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
    
    def map_source_value(source_value)
      if(@opts[:concatenate])
        HashMappingStrategies::Concatenate.map(source_value, @opts[:concatenate])
      else 
        source_value
      end 
    end

  end
  
  module HashMappingStrategies

    class Concatenate

      class << self
        
        def map(source_value, concat)
          if(source_value.kind_of?(Hash))
            concat_values_from_hash(source_value).join(concat)
          elsif(source_value.kind_of?(Array)) 
            source_value.join(concat)
          else 
            source_value
          end 
        end

        private
        
        def concat_values_from_hash(source_value)
          source_value.each do |key, value|
            unless value.is_a?(Array)
              return concat_values_from_hash(value)
            else 
              return value
            end
          end
        end
      end
    end
  end
end
