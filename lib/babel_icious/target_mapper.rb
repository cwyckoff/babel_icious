class TargetMapperError < Exception; end

module Babelicious

  class TargetMapper
    attr_reader :mappings, :direction, :target
    
    def initialize
      @mappings = []
      @target = nil
    end

    def direction=(dir)
      raise TargetMapperError, "Direction must be a hash" unless dir.is_a?(Hash)
      raise TargetMapperError, "Both :from and :to keys must be set (e.g., {:from => :xml, :to => :hash}" unless (dir[:from] && dir[:to])

      @direction = dir
    end
    
    def translate(source)
      @mappings.each do |source_element, target_element|
        filtered_source = source_element.class.filter_source(source) if filtered_source.nil?
        
        source_value = source_element.value_from(filtered_source)
        target_element.map_from(@target, source_value)
      end
      @target
    end
    
    def register_mapping(opts={})
      raise TargetMapperError, "Both :from and :to keys must be set (e.g., {:from => \"foo/bar\", :to => \"bar/foo\")" unless (opts[:from] && opts[:to])
      target = MapFactory.target(@direction, opts)
      source = MapFactory.source(@direction, opts)
      @target = target.class.initial_target if @target.nil?

      @mappings << [source, target]
    end
    
    def reset
      @mappings, @direction, @target = [], nil, nil
    end
    
  end
end

