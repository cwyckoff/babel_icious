module Babelicious

  class MapFactory
    
    def self.source(direction, opts={})
      eval("Babelicious::#{direction[:from].to_s.capitalize}Map").new(PathTranslator.new(opts[:from]), opts)
    end

    def self.target(direction, opts={})
      eval("Babelicious::#{direction[:to].to_s.capitalize}Map").new(PathTranslator.new(opts[:to]), opts)
    end

  end 


  class SourceProxy

    def self.filter_source(source)
      source
    end

    def value_from(source=nil)
      @source_value
    end 

    def with(value)
      @source_value = value
    end 

  end 

end

