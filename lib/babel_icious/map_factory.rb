class MapFactory
  
  class << self
    
    def source(direction, opts={})
      Object.const_get("#{direction[:from].to_s.capitalize}Map").new(PathTranslator.new(opts[:from]))
    end

    def target(direction, opts={})
      Object.const_get("#{direction[:to].to_s.capitalize}Map").new(PathTranslator.new(opts[:to]))
    end

  end
end 
