require 'xml'

class XmlMap
  
  def initialize(path_translator)
    @path_translator = path_translator
  end
  
  def value_from(source)
    source.find("/#{@path_translator.full_path}").each do |node|
      return node.content
    end 
  end

  def map_from(output, source)
  end
  
end
