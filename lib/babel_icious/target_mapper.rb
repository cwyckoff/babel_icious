class TargetMapperError < Exception; end

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
  
  def initial_target
    raise TargetMapperError, "please set @direction (e.g., target_mapper.direction = {:from => :xml, :to => :hash}" unless @direction
    
    case @direction[:to]
    when :xml
      XML::Document.new()
    when :hash
      {}
    end
  end 
  
  def map(source)
    target = initial_target
    @mappings.each do |source_element, target_element|
      source_value = source_element.value_from(source)
      target_element.map_from(target, source_value)
    end
    target
  end
  
  def register_mapping(opts={})
    raise TargetMapperError, "Both :from and :to keys must be set (e.g., {:from => \"foo/bar\", :to => \"bar/foo\")" unless (opts[:from] && opts[:to])

    @mappings << [MapFactory.source(@direction, opts), MapFactory.target(@direction, opts)]
  end
  
  def reset
    @mappings, @direction = [], nil
  end
  
end
