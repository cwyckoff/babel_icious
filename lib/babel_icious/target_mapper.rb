class TargetMapperError < Exception; end

module Babelicious

  class TargetMapper
    attr_reader :mappings, :direction
    
    def initialize
      @mappings = []
    end

    def direction=(dir)
      raise TargetMapperError, "Direction must be a hash" unless dir.is_a?(Hash)
      raise TargetMapperError, "Both :from and :to keys must be set (e.g., {:from => :xml, :to => :hash}" unless (dir[:from] && dir[:to])

      @direction = dir
    end
    
    def translate(source)
      target = nil
      @mappings.each do |source_element, target_element|
        target = target_element.class.initial_target if target.nil?
        filtered_source = source_element.class.filter_source(source) if filtered_source.nil?
        
        source_value = source_element.value_from(filtered_source)
        target_element.map_from(target, source_value)
      end
      target
    end
    
    def register_condition(condition_key, condition=nil, &block)
      @mappings.last[1].register_condition(condition_key, condition, &block)
    end
    
    def register_mapping(opts={})
      raise TargetMapperError, "Both :from and :to keys must be set (e.g., {:from => \"foo/bar\", :to => \"bar/foo\")" unless (opts[:from] && opts[:to])
      target = MapFactory.target(@direction, opts)
      source = MapFactory.source(@direction, opts)

      @mappings << [source, target]
    end
    
    def reset
      @mappings, @direction = [], nil
    end
    
  end
end

