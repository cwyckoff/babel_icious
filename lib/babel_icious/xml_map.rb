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

  def map_from(xml_output, source)
    @index = @path_translator.parsed_path.size - 1

    if xml_output.root.nil?
      xml_output.root = XML::Node.new(root_element)
    end 

    unless(update_node?(xml_output, source))
      populate_nodes(xml_output)
      map_from(xml_output, source)
    end 
  end
  
  private
  
  def populate_nodes(xml_output)
    return if @index == 0

    if(node = previous_node?(xml_output))
      new_node = XML::Node.new(current_element)
      node << new_node
    else 
      populate_nodes(xml_output)
    end 
  end
  
  def current_element
    @path_translator.parsed_path[@index+1]
  end

  def previous_element
    @path_translator.parsed_path[@index]
  end
  
  def previous_node?(xml_output)
    @index -= 1
    node = xml_output.find("//#{@path_translator.parsed_path[0..@index].join("/")}")
    node[0]
  end
  
  def root_element
    @path_translator.parsed_path[0]
  end
  
  def update_node?(xml_output, source)
    node = xml_output.find("/#{@path_translator.full_path}")
    unless(node.empty?)
      node[0] << source.strip
      return true
    end 
    false
  end
end
