require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

module Babelicious

  describe Object do

    describe "#new_node" do

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
