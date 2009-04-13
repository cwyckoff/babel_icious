require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

describe HashMap do 

  describe "#map_from" do 

    before(:each) do
      @target_hash = {}
      @path_translator = mock("PathTranslator", :last_index => 0)
      @hash_map = HashMap.new(@path_translator)
      @path_translator.stub!(:inject_with_index).and_yield(@target_hash, "bar", 0)
    end
    
    def do_process 
      @hash_map.map_from(@target_hash, 'foo')
    end 

    it "should set value in target map" do 
      during_process { 
        @path_translator.should_receive(:inject_with_index).with({})
      }
    end
    
    it "should apply value of source to key of target" do 
      after_process { 
        @target_hash.should == {"bar" => "foo"}
      }
    end
    
  end
  
  describe "#value_from" do 

    before(:each) do
      @target_hash = {}
      path_translator = PathTranslator.new("foo/bar")
      @hash_map = HashMap.new(path_translator)
    end
    
    it "should map value of element in path" do 
      @hash_map.value_from({:foo => {:bar => "baz"}}).should == "baz"
    end
    
  end
end
