require File.expand_path(File.dirname(__FILE__) + "/spec_helper")
require File.expand_path(File.dirname(__FILE__) + "/base_map_spec")

module Babelicious
  
  describe XmlMap do 

    before(:each) do 
      @node = mock("Nokogiri::XML::Document::Node", :content => "baz", :children => mock("Nokogiri::XML::Node", :size => 1))
      @source = mock("Nokogiri::XML::Document", :xpath => [@node])
      @path_translator = PathTranslator.new("foo/bar")
      @xml_map = @strategy = XmlMap.new(@path_translator)
    end

    it_should_behave_like "an implementation of a mapping strategy"

    describe ".initial_target" do 
      
      it "should return a libxml XML document" do 
        Nokogiri::XML::Document.stub!(:new).and_return(xml_doc = mock("Nokogiri::XML::Document", :encoding= => nil))
        
        XmlMap.initial_target.should == xml_doc
      end
    end

    describe ".filter_source" do 
      
      it "should create a new Nokogiri::XML::Document using the source string" do 
        source = '<foo><bar>baz</bar></foo>'

        # expect
        Nokogiri::XML::Document.should_receive(:parse).with(source)
        
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
        Nokogiri::XML::Node.stub!(:new).and_return(@xml_node = mock("Nokogiri::XML::Node", :empty? => false, :<< => nil))
        @target_xml = mock("Nokogiri::XML::Document", :root => nil, :xpath => [@xml_node], :root= => nil)
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

      before(:each) do 
        @child_node = mock("Nokogiri::XML::Node")
        @node = mock("Nokogiri::XML::Node", :children => [@child_node], :content => "foo")
        @source = mock("Nokogiri::XML::Document", :xpath => [@node])
      end
      
      describe "when node has only one child" do 
        
        it "should return node content" do 
          XmlMap.new(@path_translator).value_from(@source).should == "foo"
        end
        
      end

      describe "when node has only one child" do 
        
        it "should return node" do 
          @node.stub!(:children).and_return([@child_node, @child_node])
          XmlMap.new(@path_translator).value_from(@source).should == @node
        end
      end
      
    end
    
    
    describe "functional tests" do 
      
      describe "when node is not updated" do 
        
        before(:each) do 
          @xml_target = Nokogiri::XML::Document.new
          @target_xml.stub!(:xpath).and_return([])
          @new_node = mock(@xml_node = mock("Nokogiri::XML::Node", :empty? => false, :<< => nil))
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
end
