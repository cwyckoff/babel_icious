require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

module Babelicious
  
  describe XmlMap do 

    before(:each) do 
      @node = mock("Xml::Document::Node", :content => "baz", :children => mock("Xml::Document::Node", :size => 1))
      @source = mock("Xml::Document", :find => [@node])
      @path_translator = PathTranslator.new("foo/bar")
      @xml_map = XmlMap.new(@path_translator)
    end

    describe ".initial_target" do 
      
      it "should return a libxml XML document" do 
        XML::Document.stub!(:new).and_return(xml_doc = mock("XML::Document"))
        
        XmlMap.initial_target.should == xml_doc
      end
    end

    describe ".filter_source" do 
      
      it "should create a new XML::Document using the source string" do 
        source = '<foo><bar>baz</bar></foo>'

        # expect
        XML::Document.should_receive(:string).with(source)
        
        # given
        XmlMap.filter_source(source)
      end
    end
    
    describe "#value_from" do 
      
      it "should map value of element in path" do 
        @xml_map.value_from(@source).should == "baz"
      end

    end
    
    describe "#map_from" do 
      
      before(:each) do
        XML::Node.stub!(:new).and_return(@xml_node = mock("XML::Node", :empty? => false, :<< => nil))
        @target_xml = mock("XML::Document", :root => nil, :find => [@xml_node], :root= => nil)
      end
      
      def do_process 
        @xml_map.map_from(@target_xml, 'foo')
      end 

      it "should set root element in xml" do 
        during_process { 
          @target_xml.should_receive(:root=).with(@xml_node)
        }
      end
      
      describe "when node is updated" do 

        it "should set value in target node" do 
          during_process { 
            @xml_node.should_receive(:<<).with("foo")
          }
        end
      end
      
    end

    describe "#value_from" do 

      it "should delegate to XmlValueMapper" do
        # given
        path_translator = mock("PathTranslator", :full_path => "foo/bar")
        source = mock("XML::Document", :find => [node = mock("XML::Node")])
        XmlValueMapper.stub!(:new).and_return(xml_value_mapper = mock("XmlValueMapper"))

        # expect
        xml_value_mapper.should_receive(:map).with(node)

        # when
        XmlMap.new(path_translator).value_from(source)
      end 
      
    end
    
    
    describe "functional tests" do 
      
      describe "when node is not updated" do 
        
        before(:each) do 
          @xml_target = XML::Document.new
          @target_xml.stub!(:find).and_return([])
          @new_node = mock(@xml_node = mock("XML::Node", :empty? => false, :<< => nil))
        end

        def do_process
          @xml_map.map_from(@xml_target, 'baz')
        end 
        
        it "should populate parent nodes of target child" do 
          after_process { 
            @xml_target.to_s.should =~ /<foo>/
          }
        end

        it "should populate target child node" do 
          after_process { 
            @xml_target.to_s.should =~ /<bar>baz/
          }
        end
      end
        
    end
  end


  describe XmlValueMapper do
    
    describe "filtering" do 
      
      describe "when node has children" do 
        
        before(:each) do
          @path_translator = mock("PathTranslator", :full_path => "foo/bar")
          @node = mock("XML::Node", :children => [mock("XML::Node"), mock("XML::Node")])
          @source = mock("XML::Document", :find => [@node])
        end
        
        describe "concatenating" do 
          
          it "should delegate to Concatenate" do 
            # expect
            XmlMappingStrategies::Concatenate.should_receive(:map).with(@node, "|").and_return({'institutions' => "foo|bar|baz"})
            
            # given
            xml_value_mapper = XmlValueMapper.new(opts = {:concatenate => "|"})
            xml_value_mapper.map(@node)
          end
          
        end

        describe "when node has children and no options are set" do
          
          it "should map child nodes" do
            # expect
            XmlMappingStrategies::ChildNodeMapper.should_receive(:map).with(@node, {}).and_return({'institutions' => {'institution' => ['foo', 'bar', 'baz'] }})
            
            # given
            xml_value_mapper = XmlValueMapper.new({})
            xml_value_mapper.map(@node)
          end 
        end
        
      end

    end 
  end 
  
  module XmlMappingStrategies
    
    describe Concatenate do

      before(:each) do 
        @node1 = mock("XML::Node", :name => "institution", :content => "foo")
        @node2 = mock("XML::Node", :name => "institution", :content => "bar")
        @node3 = mock("XML::Node", :name => "institution", :content => "baz")
        @node = mock("XML::Node", :name => "institutions", :children => [@node1, @node2, @node3])
      end
      
      it "should build concatenation string" do 
        # expect
        @node.children.should_receive(:inject).and_return("foo|bar|baz|")
        
        # given
        Concatenate.map(@node, "|")
      end

      it "should chop trailing concatenation element from string" do 
        # given
        concat_str = "foo|bar|baz|"
        @node.children.stub!(:inject).and_return(concat_str)
        
        # expect
        concat_str.should_receive(:chop).and_return("foo|bar|baz")
        
        # when
        Concatenate.map(@node, "|")
      end
      
      it "should concatenate values from similarly named nodes" do 
        Concatenate.map(@node, "|").should == {'institutions' => "foo|bar|baz"}
      end
      
    end 
    
  end
end

