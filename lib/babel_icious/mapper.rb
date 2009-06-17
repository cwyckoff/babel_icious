class MapperError < Exception; end

module Babelicious

  class Mapper
    
    class << self
      attr_reader :direction, :current_target_map_key

      def [](key)
        mappings[key.to_sym]
      end 
      
      def config(key)
        raise MapperError, "A mapping for the key #{key} currently exists.  Are you sure you want to merge the mapping you are about to do with the existing mapping?" if mapping_already_exists?(key)

        @current_target_map_key = key
        yield self
      end

      def customize(&block)
        current_target_mapper.register_customized(&block)
      end

      def direction(dir={})
        current_target_mapper.direction = @direction = dir
      end

      def from(from_str=nil)
        current_target_mapper.register_from(from_str)
        self
      end

      def include(key, opts={})
        current_target_mapper.register_include(key, opts)
        self
      end
      
      def map(opts={})
        current_target_mapper.register_mapping(opts)
        self
      end

      def mappings
        @mapped_targets ||= {}
      end
      
      def reset
        @mapped_targets, @direction = nil, {}
      end

      def to(&block)
        current_target_mapper.register_to(&block)
        self
      end
      
      def translate(key=nil, source=nil)
        raise MapperError, "No target mapper exists for key #{key}" unless mappings.has_key?(key)
        
        mappings[key].translate(source)
      end
      
      def when(&block)
        current_target_mapper.register_condition(:when, nil, &block)
      end

      def unless(condition=nil, &block)
        current_target_mapper.register_condition(:unless, condition, &block)
        self
      end
      
      private
      
      def current_target_mapper
        mappings[@current_target_map_key] ||= TargetMapper.new
      end
      
      def mapping_already_exists?(key)
        mappings.keys.include?(key)
      end

    end
  end

end
