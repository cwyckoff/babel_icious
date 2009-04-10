require File.expand_path(File.dirname(__FILE__) + "/spec_helper")
      
describe "factories" do

   before(:all) do 
    @direction = {:from => :xml, :to => :hash}
    @xml_map = mock("XmlMap")
    @hash_map = mock("HashMap")
    @path_translator = mock("PathTranslator")
    PathTranslator.stub!(:new).and_return(@path_translator)
  end


  describe MapFactory do 
    
    describe ".source" do 

      describe "when source is xml" do 
        
        it "should instantiate XmlMap" do 
          # expect
          XmlMap.should_receive(:new).with(@path_translator).and_return(@xml_map)

          # given
          MapFactory.source(@direction, {:from => "foo/bar"})
        end
      end

      describe "when source is hash" do 
        
        it "should instantiate HashMap" do 
          # expect
          HashMap.should_receive(:new).with(@path_translator).and_return(@hash_map)

          # given
          MapFactory.source({:from => :hash, :to => :xml}, {:from => "foo/bar"})
        end
        
      end
    end 
      
    describe ".target" do 

      describe "when target is hash" do 
        
        it "should instantiate HashMap" do 
          path_translator = mock("PathTranslator")
          xml_map = mock("XmlMap")

          # expect
          HashMap.should_receive(:new).with(@path_translator).and_return(@hash_map)

          # given
          MapFactory.target(@direction, {:to => "bar/foo"})
        end
        
      end

      describe "when target is xml" do 
        
        it "should instantiate XmlMap" do 
          path_translator = mock("PathTranslator")
          hash_map = mock("HashMap")

          # expect
          XmlMap.should_receive(:new).with(@path_translator).and_return(@xml_map)

          # given
          MapFactory.target({:from => :hash, :to => :xml}, {:to => "bar/foo"})
        end
        
      end
      
    end
  end
end 
