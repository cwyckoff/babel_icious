require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

describe PathTranslator do
  
  before(:each) do 
    @translator = PathTranslator.new("bar/foo")
  end

  describe "#translate" do 
    
    it "should split path elements into array" do 
      @translator.parsed_path.should == ["bar", "foo"]
    end

    describe "leading '/'" do 
      
      it "should remove leading '/' from path" do 
        translator = PathTranslator.new("/bar/foo")
        
        translator.parsed_path.should == ["bar", "foo"]
      end
      
    end
  end
  
  describe "#each" do 

    it "should yield path elements array" do 
      @translator.each do |element|
        ["bar", "foo"].include?(element).should be_true
      end
    end
    
  end
end 
