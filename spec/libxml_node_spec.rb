require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

module Babelicious

  describe Object do

    describe "#new_node" do

      it "should create a new Nokogiri::XML::Node instance" do
        # expect
        Nokogiri::XML::Node.should_receive(:new).with do |*args|
          args.first.should == 'foo'
        end
        
        # when
        new_node("foo")
      end

      context "if block is passed" do
        
        it "should yield new instance of Nokogiri::XML::Node" do
          # given
          Nokogiri::XML::Node.stub!(:new).and_return(node = mock("Nokogiri::XML::Node"))

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

        foo_node = new_node("foo", nil, true) do |foo_node|
          foo_node << new_node("bar", nil, true) do |bar_node|
            bar_node << "baz"
          end 
        end

        foo_node.to_s.should == xml.chomp
      end 
    end

  end 
end
