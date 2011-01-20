class MapperError < Exception; end

module Babelicious

  class Mapper
    
    class << self
      attr_reader :direction, :current_map_definition_key

      def [](key)
        definitions[key.to_sym]
      end 
      
      def config(key)
        raise MapperError, "A mapping for the key #{key} currently exists.  Are you sure you want to merge the mapping you are about to do with the existing mapping?" if mapping_already_exists?(key)

        @current_map_definition_key = key
        yield self
      end

      def customize(&block)
        current_map_definition.register_customized(&block)
      end

      def definitions
        @map_definitions ||= {}
      end
      
      def direction(dir={})
        current_map_definition.direction = @direction = dir
      end

      def from(from_str=nil)
        current_map_definition.register_from(from_str)
        self
      end

      def include(key, opts={})
        current_map_definition.register_include(key, opts)
        self
      end
      
      def map(opts={})
        current_map_definition.register_rule(opts)
        self
      end

      def prepopulate(data)
        current_map_definition.register_prepopulate(data)
      end

      def reset
        @map_definitions, @direction = nil, {}
      end

      def to(&block)
        current_map_definition.register_to(&block)
        self
      end
      
      def translate(key=nil, source=nil)
        raise MapperError, "No target mapper exists for key #{key}" unless definitions.has_key?(key)
        
        definitions[key].translate(source)
      end
      
      def unless(condition=nil, &block)
        current_map_definition.register_condition(:unless, condition, &block)
        self
      end
      
      def when(&block)
        current_map_definition.register_condition(:when, nil, &block)
      end

      def gc_context
        current_map_definition.gc_context
      end
      
      private
      
      def current_map_definition
        definitions[@current_map_definition_key] ||= MapDefinition.new
      end
      
      def mapping_already_exists?(key)
        definitions.keys.include?(key)
      end

    end
  end

end
