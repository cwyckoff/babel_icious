# http://rpheath.com/posts/341-ruby-inject-with-index
unless Array.instance_methods.include?("inject_with_index")
  module Enumerable
    def inject_with_index(injected)
      each_with_index{ |obj, index| injected = yield(injected, obj, index) }
      injected
    end
  end
end

class HashMap
  
  def initialize(path_translator)
    @path_translator = path_translator
  end

  def map_from(output, source_value)

    catch :no_value do
      @path_translator.inject_with_index(output) do |hsh, element, index|
        if(hsh[element])
          hsh[element]
        else
          hsh[element] = (index == @path_translator.parsed_path.size-1 ? source_value : {})
        end 
      end
    end 
  end
end
