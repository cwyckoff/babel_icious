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

    describe "#register_customized" do 
      
      it "should delegate to target map element" do 
        # expect
        @target_element.should_receive(:register_customized)
        
        # given
        @target_mapper.register_customized
      end
      
    end

    describe "#register_from" do 
      
      it "should create new source object" do 
        # expect
        MapFactory.should_receive(:source).with({:from => :xml, :to => :hash}, {:from => "foo/bar"})
        
        # given
        @target_mapper.register_from("foo/bar")
      end

      it "should add source to mappings array" do 
        # given
        @target_mapper.reset

        # when
        @target_mapper.register_from("foo/bar")

        # expect
        @target_mapper.mappings.should == [[@source_element]]
      end 

      context "when argument is nil" do 

        it "should raise an error" do 
          running { @target_mapper.register_from(nil) }.should raise_error(TargetMapperError)
        end 
      end 

    end

    describe "#register_include" do

      before(:each) do
        Mapper.reset
        @source_path_translator = mock("PathTranslator", :unshift => nil)
        @target_path_translator = mock("PathTranslator", :unshift => nil)
        @other_source = mock("XmlMap", :path_translator => @source_path_translator)
        @other_target = mock("HashMap", :path_translator => @target_path_translator)
        TargetMapper.stub!(:new).and_return(@other_target_mapper = mock("TargetMapper", :direction= => nil, :register_mapping => nil, 
                                                                        :mappings => [[@other_source, @other_target], [@other_source, @other_target]]))
        Mapper.config(:another_mapping) do |m|
          m.direction :from => :xml, :to => :hash

          m.map :to => "lets/do", :from => "another/mapping"
        end 
      end

      context "missing mapping key" do

        it "should raise an error" do
          running { @target_mapper.register_include }.should raise_error(TargetMapperError)
        end

      end

      context "missing included mapping" do

        it "should raise an error" do
          running { @target_mapper.register_include(:foo) }.should raise_error(TargetMapperError)
        end

      end

      it "should retrieve mappings from included map definition" do
        # expect
        @other_target_mapper.should_receive(:mappings)

        # when
        @target_mapper.register_include(:another_mapping)
      end

      it "should add its own mappings to those from included map definition" do
        # when
        @target_mapper.register_include(:another_mapping)

        # expect
        @target_mapper.mappings.should == [[@source_element, @target_element], [@other_source, @other_target], [@other_source, @other_target]]
      end

      context "when included mapping is nested" do

        it "should add its own " do
          # expect
          @target_path_translator.should_receive(:unshift)

          # when
          @target_mapper.register_include(:another_mapping, {:inside_of => "barf"})
        end
        
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
      
      context "when :to or :from are not set" do 
        
        it "should raise an error" do 
          running { @target_mapper.register_mapping({})}.should raise_error(TargetMapperError)
        end
        
      end
    end

    describe "#register_to" do 
      
      it "should create new source object" do 
        # expect
        MapFactory.should_receive(:target).with({:from => :xml, :to => :hash}, {:to => '', :to_proc => nil})
        
        # given
        @target_mapper.register_to
      end

      it "should add source to mappings array" do 
        # given
        @target_mapper.reset
        @target_mapper.mappings << [@source_element]
        @target_mapper.register_to

        # expect
        @target_mapper.mappings.should == [[@source_element, @target_element]]
      end 

      context "if .from has not been set before calling .to" do 
        
        it "should raise an error" do 
          # given
          @target_mapper.reset

          running { @target_mapper.register_to }.should raise_error(TargetMapperError)
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
        @target_element.stub!(:opts).and_return({})
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

      context "when block has been passed to #to method" do 

        before(:each) do 
          @path_translator = mock("PathTranslator", :set_path => nil)
          @target_element.stub!(:path_translator).and_return(@path_translator)
          @proc = mock("Proc", :call => "baz")
          @target_element.stub!(:opts).and_return({:to_proc => @proc})
        end 

        it "should call proc" do 
          during_process { 
            @proc.should_receive(:call).and_return("baz")
          }
        end 
        
        it "should set path on path translator" do 
          during_process { 
            @path_translator.should_receive(:set_path).with("baz")
          }
        end 

        it "should map source to target element" do 
          during_process { 
            @target_element.should_receive(:map_from).with({}, "bar").and_return({})
          }
        end 

      end 
    end
  end

end

