require 'nokogiri'

module Babelicious
  
  class XmlMap < BaseMap
    attr_accessor :path_translator
    
    class << self
      
      def initial_target
        Nokogiri::XML::Document.new.tap do |d|
          d.encoding = "UTF-8"
        end
      end
      
      def filter_source(source)
        Nokogiri::XML::Document.parse(source)
      end
      
    end
    
    def initialize(path_translator, opts={})
      @path_translator, @opts = path_translator, opts
    end
    
    def value_from(source)
      source.xpath("/#{@path_translator.full_path}").each do |node|
        if(node.children.size > 1)
          return node
        else
          return node.content
        end
      end
      nil
    rescue StandardError => e
      raise "There was a problem extracting the value from your xml at mapping '#{@path_translator.full_path}' #{e.inspect}"
    end

    protected
    
    def map_output(xml_output, source_value)
      @index = @path_translator.last_index
      set_root(xml_output)

      unless(update_node?(xml_output, source_value))
        populate_nodes(xml_output)
        map_from(xml_output, source_value)
      end 

    rescue StandardError => e
      raise "There was a problem mapping the xml output for mapping '#{@path_translator.full_path}' with source value #{source_value.pretty_inspect} #{e.inspect}"
    end
    
    private

    def map_source_value(source_value)
      if(@customized_map)
        @customized_map.call(source_value).to_s
      else 
        if(source_value.is_a?(String))
          source_value.strip
        elsif(source_value.is_a?(TrueClass))
          "true"
        elsif(source_value.is_a?(FalseClass))
          "false"
        elsif (source_value.is_a?(Numeric))
          source_value.to_s
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
        value = map_source_value(source_value)
        node[0] << value
        return true
      end 
    end
  end

end
