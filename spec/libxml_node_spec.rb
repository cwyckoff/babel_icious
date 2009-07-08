require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

module Babelicious

  describe Object do

    describe "#new_node" do

      it "should create a new XML::Node instance" do
        # expect
        XML::Node.should_receive(:new).with("foo")

        # when
        new_node("foo")
      end

      context "if block is passed" do
        
        it "should yield new instance of XML::Node" do
          # given
          XML::Node.stub!(:new).and_return(node = mock("XML::Node"))

          # expect
          new_node("foo") do |nd|
            nd.should == node
          end 
        end

      end

      it "should allow recursive nestings" do
        xml = <<-EOL
<foo>
  <bar>baz</bar>
</foo>
EOL

        foo_node = new_node("foo") do |foo_node|
          foo_node << new_node("bar") do |bar_node|
            bar_node << "baz"
          end 
        end

        foo_node.to_s.should == xml.chomp
      end 
    end

  end 
end
