require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

module Babelicious

  describe "Mapper" do

    before(:each) do 
      TargetMapper.stub!(:new).and_return(@target_mapper = mock("TargetMapper", :register_mapping => nil, :direction= => nil))
    end
    
    describe ".config" do
      
      it "should yield instance of itself" do 
        Mapper.reset
        Mapper.config(:foo) do |m|
          m.should == Mapper
        end
      end

      it "should take a mapping key to register the target map" do 
        # given
        Mapper.reset
        Mapper.config(:foo) {}
        
        # expect
        Mapper.current_target_map_key.should == :foo
      end
      
      describe "when a mapping key already exists" do 
        
        it "should raise an error" do 
          # given
          Mapper.config(:bar) { |m| m.direction :from => :xml, :to => :hash }
          
          # expect
          running { Mapper.config(:bar) {} }.should raise_error(MapperError)
        end
      end
      
    end

    describe ".direction" do 
      
      it "should set direction of the mapping" do 
        # expect
        @target_mapper.should_receive(:direction=).with({:from => :xml, :to => :hash})

        # given
        Mapper.reset
        Mapper.config(:foo) do |m|
          m.direction :from => :xml, :to => :hash
        end
      end
      
    end
    
    describe ".map" do 
      
      before(:each) do
        Mapper.reset
        @opts = {:to => "bar/foo", :from => "foo/bar"}
        Mapper.config(:foo) { |m| m.direction :from => :xml, :to => :hash}
      end
      
      it "should register mappings" do 
        # expect
        @target_mapper.should_receive(:register_mapping).with(@opts)

        # given
        Mapper.map @opts
      end
      
    end

    describe ".reset" do 
      
      it "should reset direction" do 
        # when
        Mapper.reset
        
        # expect
        Mapper.direction.should == {}
      end

      it "should reset mappings" do 
        # when
        Mapper.reset
        
        # expect
        Mapper.mappings.should == {}
      end
    end
    
    describe ".translate" do 

      before(:each) do
        @xml = '<foo><bar>baz</baz></foo>'
        Mapper.reset
        Mapper.config(:foo) do |m| 
          m.direction :from => :xml, :to => :hash
          m.map :from => "foo/bar", :to => "bar/foo"
        end
      end

      it "should map target elements" do 
        # expect
        @target_mapper.should_receive(:translate).with(@xml).and_return({})

        # given
        Mapper.translate(:foo, @xml)
      end
      
      describe "when no key exists for target mapper" do 
        
        it "should raise an error" do 
          running { Mapper.translate(:bar, @xml) }.should raise_error(MapperError)
        end
      end
      
    end

    
    describe "mapping conditions" do 

      before(:each) do
        Mapper.reset
        @opts = {:to => "bar/foo", :from => "foo/bar"}
        Mapper.config(:foo) { |m| m.direction :from => :xml, :to => :hash}
      end
      
      describe ".when" do 

        it "should delegate it to target mapper" do 
          # expect
          @target_mapper.should_receive(:register_condition) #.with(:when, an_instance_of(Proc)).and_return(@when_conditions)
          
          # given
          Mapper.map(@opts).when do |value|
            value =~ /baz/
          end
        end
        
      end

      describe ".unless" do 

        it "should delegate it to target mapper" do 
          # expect
          @target_mapper.should_receive(:register_condition).with(:unless, :nil) #.with(:when, an_instance_of(Proc)).and_return(@when_conditions)
          
          # given
          Mapper.map(@opts).unless(:nil)
        end
        
      end
      
    end
  end
  
end
