require 'rubygems'
require 'ruby-debug'
require 'xml'
require File.expand_path(File.dirname(__FILE__) + "/../target_mapper")
require File.expand_path(File.dirname(__FILE__) + "/../factories")
require File.expand_path(File.dirname(__FILE__) + "/../path_translator")
require File.expand_path(File.dirname(__FILE__) + "/../xml_map")
require File.expand_path(File.dirname(__FILE__) + "/../hash_map")
require File.expand_path(File.dirname(__FILE__) + "/../mapper")

Mapper.config(:foo) do |m|
  m.direction = {:from => :xml, :to => :hash}

  m.map :from => "foo/bar", :to => "bar/foo"
  m.map :from => "foo/baz", :to => "bar/boo"
  m.map :from => "foo/cuk/coo", :to => "foo/bar/coo"
  m.map :from => "foo/cuk/doo", :to => "doo"
end

xml = '<foo><bar>a</bar><baz>b</baz><cuk><coo>c</coo><doo>d</doo></cuk></foo>'
source = XML::Document.string(xml)
puts "merged hash: #{Mapper.translate(:foo, source).inspect}"

