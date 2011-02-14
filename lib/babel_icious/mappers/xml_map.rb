require 'nokogiri'

module Babelicious
  
  class XmlMap < BaseMap
    attr_accessor :path_translator
    
    class << self
      
      def initial_target
        d = Nokogiri::XML::Document.new
        d.encoding = 'UTF-8'
        d
      end
      
      def filter_source(source)
        Nokogiri::XML::Document.parse(source)
      end
      
    end
    
    def initialize(path_translator, opts={})
      @path_translator, @opts, @gc_context = path_translator, opts, Nokogiri::XML::Document.new
    end
    
    def value_from(source)
      source.xpath("/#{@path_translator.full_path}").each do |node|
        if(node.children.size > 1)
          return node
        else
          return node.content
        end
      end

      # rescue
      #   raise "There was a problem extracting the value from your xml at mapping '#{@path_translator.full_path}'"
    end

    protected
    
    def map_output(xml_output, source_value)
      @index = @path_translator.last_index
      set_root(xml_output)

      unless(update_node?(xml_output, source_value))
        populate_nodes(xml_output)
        map_from(xml_output, source_value)
      end 

      # rescue Exception => e
      #   raise "There was a problem mapping the xml output for mapping '#{@path_translator.full_path}' with source value #{source_value}"
    end
    
    private

    def map_source_value(source_value)
      if(@customized_map)
        @customized_map.call(source_value, @gc_context)
      else 
        if(source_value.is_a?(String))
          source_value.strip
        elsif(source_value.is_a?(TrueClass))
          "true"
        elsif(source_value.is_a?(FalseClass))
          "false"
        else
          source_value
        end 
      end 
    end

    def populate_nodes(xml_output)
      return if @index == 0

      if(node = previous_node(xml_output))
        new_node = Nokogiri::XML::Node.new(@path_translator[@index+1], xml_output)
        node << new_node
      else 
        populate_nodes(xml_output)
      end 
    end

    def previous_node(xml_output)
      @index -= 1
      node = xml_output.xpath("//#{@path_translator[0..@index].join("/")}")
      node[0]
    end
    
    def set_root(xml_output)
      if xml_output.root.nil?
        xml_output.root = Nokogiri::XML::Node.new(@path_translator[0], xml_output)
      end 
    end
    
    def update_node?(xml_output, source_value)
      node = xml_output.xpath("/#{@path_translator.full_path}")
      unless(node.empty?)
        node[0] << map_source_value(source_value) # source_value.strip unless source_value.nil?
        return true
      end 
    end
  end

end
