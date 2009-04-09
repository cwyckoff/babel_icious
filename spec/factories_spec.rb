require File.expand_path(File.dirname(__FILE__) + "/spec_helper")
      
describe "factories" do

   before(:all) do 
    @direction = {:from => :xml, :to => :hash}
    @xml_map_element = mock("XmlMap")
    @hash_map_element = mock("HashMapElement")
    @path_translator = mock("PathTranslator")
    PathTranslator.stub!(:new).and_return(@path_translator)
  end


  describe SourceMap do 
    
    describe "when source is xml" do 
      
      it "should instantiate XmlElement" do 
        # expect
        XmlMap.should_receive(:new).with(@path_translator).and_return(@xml_map_element)

        # given
        SourceMap.instance(@direction, {:from => "foo/bar"})
      end
    end

    describe "when source is hash" do 
      
      it "should "
      
    end
    
  end

  describe TargetMap do 

    
    describe "when target is xml" do 

      it "should "
      
    end

    describe "when target is hash" do 
      
      it "should instantiate HashElement" do 
        path_translator = mock("PathTranslator")
        xml_map_element = mock("XmlMap")

        # expect
        HashMap.should_receive(:new).with(@path_translator).and_return(@hash_map_element)

        # given
        TargetMap.instance(@direction, {:to => "bar/foo"})
      end
      
    end
    
  end
end 
