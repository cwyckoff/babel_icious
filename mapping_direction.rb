class MappingDirectionError < Exception; end

class MappingDirection

  def initialize(dir)
    raise MappingDirectionError, "Direction must be a hash" unless dir.is_a?(Hash)
    raise MappingDirectionError, "Both :from and :to keys must be set (e.g., {:from => :xml, :to => :hash}" unless (dir[:from] && dir[:to])

    @direction = dir
  end
  
  def [](key)
    @direction[key]
  end
  
  def initial_target
    case @direction[:to]
    when :xml
      ''
    when :hash
      {}
    end
  end 
  
end
