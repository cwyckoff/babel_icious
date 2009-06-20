require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

module Babelicious

  describe PathTranslator do
    
    before(:each) do 
      @translator = PathTranslator.new("bar/foo")
    end

    describe "#[]" do 
      
      it "should return element from parsed path array at specified index" do 
        @translator[1].should == "foo"
      end
    end
    
    describe "#each" do 

      it "should yield path elements array" do 
        @translator.each do |element|
          ["bar", "foo"].include?(element).should be_true
        end
      end
      
    end

    describe "#last" do 
      
      it "should return last element in path" do 
        @translator.last.should == "foo"
      end
    end
    
    describe "#last_index" do 
      
      it "should return index of last element in parsed path array" do 
        @translator.last_index.should == 1
      end
    end

    describe "#size" do 
      
      it "should return size of path elements" do 
        @translator.size.should == 2
      end
      
    end

    describe "#set_path" do 
      
      def do_process
        @translator.set_path("foo/bar")
      end 

      it "should set full_path" do 
        after_process { 
          @translator.full_path.should == "foo/bar"
        }
      end 

      it "should set parsed_path" do 
        after_process { 
          @translator.parsed_path.should == ["foo", "bar"]
        }
      end 

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

    describe "#dup" do
      
      it "deep dups all of the attributes" do
        dupd = @translator.dup
        dupd.full_path.object_id.should_not == @translator.full_path.object_id
        dupd.parsed_path.object_id.should_not == @translator.parsed_path.object_id
      end
      
    end
    
  end 
end
