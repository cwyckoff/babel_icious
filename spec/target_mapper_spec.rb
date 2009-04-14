require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

module Babelicious

  describe TargetMapper do 
    
    before(:each) do
      xml = '<foo>bar</foo>'
      MapFactory.stub!(:source).and_return(@source_element = mock("XmlMap", :value_from => "bar"))
      MapFactory.stub!(:target).and_return(@target_element = mock("HashMap", :map_from => {}))
      @target_mapper = TargetMapper.new
      @target_mapper.direction = {:from => :xml, :to => :hash}
      @opts = {:to => "bar/foo", :from => "foo/bar"}
      @target_mapper.register_mapping(@opts)
    end
    
    describe "#translate" do 

      before(:each) do 
        @xml = '<foo>bar</foo>'
        @source_element.stub!(:class).and_return(@xml_map_klass = mock("XmlMapKlass", :filter_source => @xml))
        @target_element.stub!(:class).and_return(@hash_map_klass = mock("HashMapKlass", :initial_target => {}))
      end
      
      def do_process
        @target_mapper.translate('<foo>bar</foo>')
      end
      
      it "should map target to elements for mapping" do 
        during_process { 
          @target_element.should_receive(:map_from).and_return({})
        }
      end
      
      it "should delegate the source to the source element for filtering" do 
        during_process { 
          @xml_map_klass.should_receive(:filter_source).with(@xml).once
        }
      end

      it "should delegate creation of the initial target to the target element" do 
        during_process { 
          @hash_map_klass.should_receive(:initial_target).once
        }
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

