module Babelicious

  class MapFactory
    
    class << self
      
      def source(direction, opts={})
        eval("Babelicious::#{direction[:from].to_s.capitalize}Map").new(PathTranslator.new(opts[:from]))
      end

      def target(direction, opts={})
        eval("Babelicious::#{direction[:to].to_s.capitalize}Map").new(PathTranslator.new(opts[:to]))
      end

    end

  end 
end

