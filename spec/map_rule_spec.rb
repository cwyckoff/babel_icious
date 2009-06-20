require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

module Babelicious

  describe MapRule do

    describe "setting source and target" do

      before(:each) do
        @map_rule = MapRule.new
      end
      
      context "#source=" do

        it "should set source mapping" do
          # given
          @map_rule.source = @source

          # expect
          @map_rule.source.should == @source
        end

      end

      context "#target=" do

        it "should set target mapping" do
          # given
          @map_rule.target = @target

          # expect
          @map_rule.target.should == @target
        end

      end

    end

    describe "getting source and target" do

      before(:each) do
        @source = mock("XmlMap")
        @target = mock("HashMap")
        @map_rule = MapRule.new(@source, @target)
      end

      context "#source" do

        it "should return source mapping" do
          # expect
          @map_rule.source.should == @source
        end

      end

      context "#target" do

        it "should return target mapping" do
          # expect
          @map_rule.target.should == @target
        end

      end

    end 

    context "#filtered_source" do

      it "should delegate to source strategy" do
        # given
        source = mock("HashMap", :class => HashMap)
        target = mock("HashMap")
        map_rule = MapRule.new(source, target)

        # expect
        HashMap.should_receive(:filter_source).with({:foo => "bar"})
        
        # when
        map_rule.filtered_source({:foo => "bar"})
      end

      it "should return filtered source data structure for source strategy" do
        # given
        source = mock("HashMap", :class => HashMap)
        target = mock("HashMap")
        map_rule = MapRule.new(source, target)

        # expect
        map_rule.filtered_source({:foo => "bar"}).should == {:foo => "bar"}
      end

    end

    context "#initial_target" do

      it "should delegate to target strategy" do
        # given
        source = mock("XmlMap")
        target = mock("HashMap", :class => HashMap)
        map_rule = MapRule.new(source, target)

        # expect
        HashMap.should_receive(:initial_target)
        
        # when
        map_rule.initial_target
      end

      it "should return initial target data structure for target strategy" do
        # given
        source = mock("XmlMap")
        target = mock("HashMap", :class => HashMap)
        map_rule = MapRule.new(source, target)

        # expect
        map_rule.initial_target.should == {}
      end

    end

    context "#translate" do

      before(:each) do
        @source = mock("XmlMap")
        @target = mock("HashMap", :opts => { }, :map_from => nil)
        @map_rule = MapRule.new(@source, @target)
        @target_data = { }
        @source_value = '<foo>bar</foo>'
      end

      context "target mapping to_proc option is set" do

        before(:each) do
          @path_translator = mock("PathTranslator", :set_path => nil)
          @target_with_proc = mock("HashMap", :opts => {:to_proc => Proc.new { }}, 
                                   :map_from => nil, :path_translator => @path_translator)
          @map_rule = MapRule.new(@source, @target_with_proc)
        end

        it "should delegate to path_translator" do
          # expect
          @target_with_proc.should_receive(:path_translator).and_return(@path_translator)

          # when
          @map_rule.translate(@target_data, @source_value)
        end
        
        it "should delegate mapping to target element" do
          # expect
          @target_with_proc.should_receive(:map_from).with(@target_data, @source_value)

          # when
          @map_rule.translate(@target_data, @source_value)
        end
        
      end

      it "should delegate mapping to target element" do
        # expect
        @target.should_receive(:map_from).with(@target_data, @source_value)

        # when
        @map_rule.translate(@target_data, @source_value)
      end
      
    end
    
  end 
end
