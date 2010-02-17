module Babelicious

  class ObjectMap < BaseMap
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
      value = source
      @path_translator.full_path.split("/").each do |method|
        value = value.send(method.to_sym)
      end
      value
    end

  end
end
