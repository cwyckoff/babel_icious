require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

module Babelicious
  
  describe MapCondition do 

    before(:each) do
      @map_condition = MapCondition.new
    end
    
    describe "#is_satisfied_by" do 
      
      describe "'when' condition" do 
        
        describe "when it's satisfied" do 
          
          it "should return true" do 
            @map_condition.register(:when, nil) { |value| value =~ /fo/ }
            @map_condition.is_satisfied_by("foo").should be_true
          end
        end

        describe "when condition is not satisfied" do 
          
          it "should return nil" do 
            @map_condition.register(:when, nil) { |value| value =~ /baz/ }
            @map_condition.is_satisfied_by("foo").should be_nil
          end
        end
        
      end

      describe "'unless' condition" do 
        
        describe "when it's satisfied" do 
          
          it "should return true" do 
            @map_condition.register(:unless, :nil)
            @map_condition.is_satisfied_by("foo").should be_true
          end
        end

        describe "when condition is not satisfied" do 
          
          it "should return false" do 
            @map_condition.register(:unless, :empty)
            @map_condition.is_satisfied_by('').should be_false
          end
        end
        
      end
    end
  end
end

