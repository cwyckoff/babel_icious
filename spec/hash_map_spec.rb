require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

describe HashMap do 
  
  describe "#map" do 

    before(:each) do
      @target_hash = {}
      @path_translator = mock("PathTranslator", :parsed_path => ["bar"])
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
end
