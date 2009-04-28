require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

module Babelicious

  describe TargetMapper do 
    
    before(:each) do
      xml = '<foo>bar</foo>'
      @hash_map_klass = mock("HashMapKlass", :initial_target => {})
      MapFactory.stub!(:source).and_return(@source_element = mock("XmlMap", :value_from => "bar"))
      MapFactory.stub!(:target).and_return(@target_element = mock("HashMap", :map_from => {}, :class => @hash_map_klass))
      @target_mapper = TargetMapper.new
      @target_mapper.direction = {:from => :xml, :to => :hash}
      @opts = {:to => "bar/foo", :from => "foo/bar"}
      @target_mapper.register_mapping(@opts)
    end
    
    
    describe "#register_condition" do 
      
      it "should delegate to target map" do 
        # expect
        @target_element.should_receive(:register_condition).with(:unless, :nil)
        
        # given
        @target_mapper.register_condition(:unless, :nil)
      end
      
    end
    
    describe "#register_mapping" do 

      def do_process
        @target_mapper.reset
        @target_mapper.direction = {:from => :xml, :to => :hash}
        @target_mapper.register_mapping(@opts)
        @source_element.stub!(:class).and_return(@xml_map_klass = mock("XmlMapKlass", :filter_source => @xml))
      end
      
      it "should register target or source mapping" do 
        during_process { 
          @target_mapper.mappings.should == [[@source_element, @target_element]]
        }
      end

      describe "setting target" do 

        describe "when map is called multiple times" do 

          def do_process
            @target_mapper.reset
            @target_mapper.direction = {:from => :xml, :to => :hash}
            @target_mapper.register_mapping({:to => "bar/foo", :from => "foo/bar"})
            @target_mapper.register_mapping({:to => "bar/baz", :from => "foo/baz"})
            @target_mapper.register_mapping({:to => "bar/boo", :from => "foo/boo"})
          end
          
          it "should delegate creation of the initial target to the target element" do 
            pending
            during_process { 
              @hash_map_klass.should_receive(:initial_target).once.and_return({})
            }
          end
          
        end
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
    
    describe "#translate" do 

      before(:each) do 
        @xml = '<foo>bar</foo>'
        @source_element.stub!(:class).and_return(@xml_map_klass = mock("XmlMapKlass", :filter_source => @xml))
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
      
    end
  
  end

end

