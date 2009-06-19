require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

module Babelicious

  describe BaseMap do
    
  end 
  
end 


describe "an implementation of a mapping strategy", :shared => true do
  
  describe "#dup" do
    
    it "deep dups all of its attributes" do
      dupd = @strategy.dup
      dupd.opts.object_id.should_not == @strategy.opts.object_id
      dupd.path_translator.object_id.should_not == @strategy.path_translator.object_id
    end
    
  end
  
end 
