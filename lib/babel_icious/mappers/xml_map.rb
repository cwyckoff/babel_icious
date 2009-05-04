require 'xml'

module Babelicious
  
  class XmlMap < BaseMap
    
    class << self
      
      def initial_target
        XML::Document.new
      end
      
      def filter_source(source)
        XML::Document.string(source)
      end
      
    end
    
    def initialize(path_translator, opts={})
      @path_translator, @opts = path_translator, opts
      @xml_value_mapper = XmlValueMapper.new(@path_translator, @opts)
    end
    
    def value_from(source)
      source.find("/#{@path_translator.full_path}").each do |node|
        return @xml_value_mapper.map(node)
      end
    end

    private
    
    def map_output(xml_output, source_value)
      @index = @path_translator.last_index

      set_root(xml_output)
      
      unless(update_node?(xml_output, source_value))
        populate_nodes(xml_output)
        map_from(xml_output, source_value)
      end 
    end
    
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

  
  class XmlValueMapper

    def initialize(path_translator, opts={})
      @path_translator, @opts = path_translator, opts
    end
    
    def map(node)
      if(node.children.size > 1)
        content = {}
         XmlMappingStrategies::ChildNodeMapper.map(node, content)
#        return map_with_strategies_for_children(node, content)
      else
        return node.content
      end
    end

    private
    
#     def map_with_strategies_for_children(node, content)
#       if @opts[:concatenate]
#         XmlMappingStrategies::Concatenate.map(node, @opts[:concatenate], @path_translator.last)
#       else 
#         XmlMappingStrategies::ChildNodeMapper.map(node, content)
#       end
#     end
  end
  
  
  module XmlMappingStrategies

    class Concatenate
      
      class << self
        
        def map(node, concat_value, key)
          concatenated_children = node.children.inject('') {|a,b| a << "#{b.content}#{concat_value}"}
          {key => concatenated_children.chop}
        end

      end
    end

    class ChildNodeMapper

      class << self

        def map(node, content)
          node.each_element do |child|
            if(content[child.name])
              update_content_key(content, child)
            else
              create_content_key(content, child)
            end 
          end
          {node.name => content}
        end
        
        private
        
        def content_value_is_array?(content, child) 
          content[child.name].is_a?(Array)
        end 
        
        def create_content_key(content, child)
          unless grandchild_is_final_node(child)
            content[child.name] = {child.child.name => child.child.content}
          else 
            set_grandchild_value_in_array(content, child)
          end
        end
        
        def grandchild_is_final_node(child)
          !child.children? || child.child.name == "text"
        end
        
        def set_grandchild_value_in_array(content, child)
          content[child.name] = [] unless content_value_is_array?(content, child)
          if(child.children?)
            content[child.name] << child.child.content
          else
            content[child.name] = ""
          end 
        end

        def update_content_key(content, child)
          unless grandchild_is_final_node(child)
            content[child.name] = [content[child.name]] unless content_value_is_array?(content, child) 
            content[child.name] << {child.child.name => child.child.content}
          else 
            set_grandchild_value_in_array(content, child)
          end
        end
      end
    end
    
  end
end
