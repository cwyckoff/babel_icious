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
      @source.value_from(src)
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

  end 

end 
