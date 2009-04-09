class SourceMapError < Exception; end
class TargetMapError < Exception; end

class SourceMap
  
  class << self
    
    def instance(direction, opts={})
      case direction[:from]
      when :xml
        XmlMap.new(PathTranslator.new(opts[:from]))
      end
    end
  end
end 

class TargetMap
  
  class << self
    
    def instance(direction, opts={})
      case direction[:to]
      when :hash
        @target = :hash
        HashMap.new(PathTranslator.new(opts[:to]))
      end
    end
  end
end 
