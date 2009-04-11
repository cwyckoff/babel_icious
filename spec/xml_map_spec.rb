require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

describe XmlMap do 
  
  before(:each) do 
    @node = mock("Xml::Document::Node", :content => "baz")
    @source = mock("Xml::Document", :find => [@node])
    @path_translator = mock("PathTranslator", :full_path => "foo/bar")
    @xml_map = XmlMap.new(@path_translator)
  end
  
  describe "#value_from" do 
    
    it "should map value of element in path" do 
      @xml_map.value_from(@source).should == "baz"
    end
    
  end
  
  describe "#map_from" do 
    
    before(:each) do
      @target_xml = mock("Xml::Document")
      @path_translator = mock("PathTranslator", :parsed_path => ["bar"])
      @xml_map = XmlMap.new(@path_translator)
      @path_translator.stub!(:inject_with_index).and_yield(@target_xml, "bar", 0)
    end
    
    def do_process 
      @xml_map.map_from(@target_xml, 'foo')
    end 

    it "should set value in target map" do 
      during_process { 
        pending
#        @path_translator.should_receive(:inject_with_index).with(@target_xml)
      }
    end
    
    it "should apply value of source to key of target" do 
      pending
      after_process { 
        @target_xml.should == '<bar>foo</bar>'
      }
    end
    
  end
end
