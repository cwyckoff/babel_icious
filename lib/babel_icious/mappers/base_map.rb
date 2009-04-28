module Babelicious
  
  class BaseMap
    
    def map_from(output, source_value)
      if map_condition?
          map_output(output, source_value) if map_condition.is_satisfied_by(source_value)
      else 
          map_output(output, source_value)
      end 
    end
    
    def register_condition(condition_key, condition, &block)
      map_condition.register(condition_key, condition, &block)
    end
    
    protected

    def map_condition
      @map_condition ||= MapCondition.new
    end

    def map_condition?
      @map_condition
    end
    
  end
  
end
