require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

module Babelicious

  describe HashMap do 

    describe ".initial_target" do 
      
      it "should return an empty hash" do 
        HashMap.initial_target.should == {}
      end
    end

    describe ".filter_source" do 
      
      it "should return source unfiltered" do
        source = {:foo => {:bar => "baz"}}
        HashMap.filter_source(source).should == source
      end
    end

    before(:each) do
      @path_translator = mock("PathTranslator", :last_index => 0)
      @strategy = HashMap.new(@path_translator)
    end
    
    it_should_behave_like "an implementation of a mapping strategy"

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
      
      describe "map condition is set" do 

        before(:each) do 
          MapCondition.stub!(:new).and_return(@map_condition = mock("MapCondition", :register => nil, :is_satisfied_by => true))
          @hash_map.register_condition(:when, nil) { |value| value =~ /f/ }
        end
        
        it "should ask map condition to verify source value" do 
          during_process { 
            @map_condition.should_receive(:is_satisfied_by).with("foo")
          }
        end
        
        describe "map condition verifies source" do
          
          it "should map hash" do 
            during_process { 
              @path_translator.should_receive(:inject_with_index).with({})
            }
          end

        end 
      end

      describe "map condition is not set" do 
        
        it "should ignore map condition" do 
          during_process { 
            MapCondition.should_not_receive(:new)
          }
        end
        
      end
    end
    
    describe "#register_condition" do 

      it "should register condition with MapCondition" do
        # given
        MapCondition.stub!(:new).and_return(map_condition = mock("MapCondition", :register => nil))
        hash_map = HashMap.new(mock("PathTranslator"))
        
        # expect
        map_condition.should_receive(:register) #.with(:when, an_instance_of(Proc))
        
        # when
        hash_map.register_condition(:when, nil) {|value| value =~ /f/ }
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

end
