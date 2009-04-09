require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

describe XmlMap do 
  
  before(:each) do 
    @node = mock("Xml::Document::Node", :content => "baz")
    @source = mock("Xml::Document", :find => [@node])
    @path_translator = mock("PathTranslator", :full_path => "foo/bar")
    @xml_map = XmlMap.new(@path_translator)
  end
  
  describe "#value" do 
    
    it "should map value of element in path" do 
      @xml_map.value_from(@source).should == "baz"
    end
    
  end
end
