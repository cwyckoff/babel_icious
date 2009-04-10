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
    flag = false
    path = "/"
    nodes = []

    @path_translator.each_with_index do |element, index|
      if xml_output.root.nil?
        xml_output.root = XML::Node.new(element)
      else
        path += "/#{element}"
        x_path = xml_output.find("#{path}")
        if x_path.empty?
          unless nodes.empty?
            nodes.last << XML::Node.new(element)
            nodes.last.child << source.strip if (index == @path_translator.parsed_path.size-1)
          else
            # check for parent using xpath
            parent_node = previous_node(xml_output, path)
            if parent_node && (index == @path_translator.parsed_path.size-1)
              new_node = XML::Node.new(element)
              new_node << source.strip
              if(parent_node.is_a?(LibXML::XML::Document))
                parent_node = parent_node.root
              end 
              parent_node << new_node
              nodes << parent_node
              flag = true
            else
              nodes << XML::Node.new(element)
              nodes.last << source.strip if (index == @path_translator.parsed_path.size-1)
            end
          end
        end
      end

      unless flag
        nodes.each do |node|
          xml_output.root << node
          node = nil
        end
      end
    end
  end
  
  private
  
  def previous_node(xml_output, path)
    previous_path = path.split("/")
    previous_path.pop
    node = xml_output.find(previous_path.join("/"))
    node[0]
  end
end


#     path = "/"
#     nodes = []
#     @path_translator.each_with_index do |element, index|
#       if xml_output.root.nil?
#         xml_output.root = XML::Node.new(element)
#       else
#         path += "/#{element}"
#         x_path = xml_output.find("#{path}")
#         if x_path.empty?
#           unless nodes.empty?
#             nodes.last << XML::Node.new(element)
#             nodes.last.child << source.strip if (index == @path_translator.parsed_path.size-1)
#           else
#             nodes << XML::Node.new(element)
#             nodes.last << source.strip if (index == @path_translator.parsed_path.size-1)
#           end
#         end
#       end

#       nodes.each do |node|
#         xml_output.root << node
#         node = nil
#       end
#     end
