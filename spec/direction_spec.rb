require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

describe MappingDirection do 

  describe "#[]" do 
    
    it "should return direction value based on key" do 
      dir = MappingDirection.new({:to => :hash, :from => :xml})
      dir[:to].should == :hash
    end
    
  end
  
  describe "when missing :from or :to" do 
    
    it "should raise an error" do 
      running {MappingDirection.new({:foo => "bar", :baz => "boo"})}.should raise_error(MappingDirectionError)
    end

  end

  describe "if not passing a hash" do 
    
    it "should raise an error" do 
      running {MappingDirection.new('foo')}.should raise_error(MappingDirectionError)
    end

  end
  
  describe "#initial_target" do 
    
    before(:each) do 
    end
    
    describe "when target is :hash" do 

      it "should return an empty hash" do 
        MappingDirection.new({:to => :hash, :from => :xml}).initial_target.should == {}
      end

    end

    describe "when target is :xml" do 

      it "should return an empty string" do 
        MappingDirection.new({:to => :xml, :from => :hash}).initial_target.should == ''
      end

    end

  end
end

