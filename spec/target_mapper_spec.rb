require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

module Babelicious

  describe TargetMapper do 
    
    before(:each) do
      MapFactory.stub!(:source).and_return(@source_element = mock("XmlMap", :value_from => "bar"))
      MapFactory.stub!(:target).and_return(@target_element = mock("HashMap", :map_from => {}))
      @target_mapper = TargetMapper.new
      @target_mapper.direction = {:from => :xml, :to => :hash}
      @opts = {:to => "bar/foo", :from => "foo/bar"}
      @target_mapper.register_mapping(@opts)
    end
    
    describe "#map" do 

      it "should map target to elements for mapping" do 
        # expect
        @target_element.should_receive(:map_from).and_return({})

        # given
        @target_mapper.map('<foo>bar</foo>')
      end
      
      describe "when direction is not set" do 
        
        it "should raise an error" do 
          # given
          @target_mapper.reset
          @target_mapper.register_mapping(@opts)

          # expect
          running { @target_mapper.map('<foo>bar</foo>') }.should raise_error(TargetMapperError)
        end
      end
      
    end
    
    describe "#register_mapping" do 

      def do_process
        @target_mapper.reset
        @target_mapper.direction = {:from => :xml, :to => :hash}
        @target_mapper.register_mapping(@opts)
      end
      
      it "should register target or source mapping" do 
        during_process { 
          @target_mapper.mappings.should == [[@source_element, @target_element]]
        }
      end

      it "should instantiate 'from' mapping element" do 
        during_process { 
          MapFactory.should_receive(:source).with(@target_mapper.direction, @opts).and_return(@source_element)
        }
      end

      it "should instantiate 'to' mapping element" do 
        during_process { 
          MapFactory.should_receive(:target).with(@target_mapper.direction, @opts).and_return(@target_element)
        }
      end
      
      describe "when :to or :from are not set" do 
        
        it "should raise an error" do 
          running { @target_mapper.register_mapping({})}.should raise_error(TargetMapperError)
        end
        
      end
    end

    describe "#reset" do 
      
      it "should set mappings and direction to nil" do 
        # given
        @target_mapper.reset
        
        # expect
        @target_mapper.mappings.should be_empty
        @target_mapper.direction.should be_nil
      end
    end
    
  end

end

