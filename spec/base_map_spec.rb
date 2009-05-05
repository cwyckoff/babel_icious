require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

module Babelicious

  describe BaseMap do
    
    describe "#register_merge" do 
      
      it "should raise error" do 
        pending
       # given
        base_map = BaseMap.new
        
        running {base_map.register_merge("foo/bar")}.should raise_error(BaseMapError)
      end

    end
  end 
  
end 
