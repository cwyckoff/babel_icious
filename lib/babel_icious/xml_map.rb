require 'xml'

module Babelicious

  class XmlMap
    
    class << self
      
      def initial_target
        XML::Document.new
      end
      
      def filter_source(source)
        XML::Document.string(source)
      end
      
    end
    
    def initialize(path_translator)
      @path_translator = path_translator
    end
    
    def value_from(source)
      source.find("/#{@path_translator.full_path}").each do |node|
        return node.content
      end
    end

    def map_from(xml_output, source_value)
      @index = @path_translator.last_index

      set_root(xml_output)
      
      unless(update_node?(xml_output, source_value))
        populate_nodes(xml_output)
        map_from(xml_output, source_value)
      end 
    end
    
    private
    
    def populate_nodes(xml_output)
      return if @index == 0

      if(node = previous_node(xml_output))
        new_node = XML::Node.new(@path_translator[@index+1])
        node << new_node
      else 
        populate_nodes(xml_output)
      end 
    end

    def previous_node(xml_output)
      @index -= 1
      node = xml_output.find("//#{@path_translator[0..@index].join("/")}")
      node[0]
    end
    
    def set_root(xml_output)
      if xml_output.root.nil?
        xml_output.root = XML::Node.new(@path_translator[0])
      end 
    end
    
    def update_node?(xml_output, source_value)
      node = xml_output.find("/#{@path_translator.full_path}")
      unless(node.empty?)
        node[0] << source_value.strip
        return true
      end 
      false
    end
  end

end
