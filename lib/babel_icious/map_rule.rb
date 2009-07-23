module Babelicious

  class MapRule
    attr_accessor :source, :target

    def initialize(source=nil, target=nil)
      @source, @target = source, target
    end 

    def filtered_source(source)
      @source.class.filter_source(source)
    end 

    def initial_target
      @target.class.initial_target
    end 

    def source_path
      @source.path_translator.full_path
    end 

    def source_value(src)
      if map_condition?
        @source.value_from(src) if map_condition.is_satisfied_by(source_value)
      else 
        @source.value_from(src)
      end 
    end 

    def target_path
      @target.path_translator.full_path
    end 

    def translate(target_data, source_value)
      if(@target.opts[:to_proc])
        @target.path_translator.set_path(@target.opts[:to_proc].call(source_value))
        @target.map_from(target_data, source_value)
      else 
        @target.map_from(target_data, source_value)
      end 
    end 

    private

    def map_condition
      @map_condition ||= MapCondition.new
    end

    def map_condition?
      @map_condition
    end
    
  end 

end 
