Given /^a mapping exists for xml to hash$/ do
  Mapper.config(:foo) do |m|
    m.direction = {:from => :xml, :to => :hash}

    m.map :from => "foo/bar", :to => "bar/foo"
    m.map :from => "foo/baz", :to => "bar/boo"
    m.map :from => "foo/cuk/coo", :to => "foo/bar/coo"
    m.map :from => "foo/cuk/doo", :to => "doo"
  end
end

When /^the mapping is translated$/ do
  xml = '<foo><bar>a</bar><baz>b</baz><cuk><coo>c</coo><doo>d</doo></cuk></foo>' 
  source = XML::Document.string(xml)
  @translated_hash = Mapper.translate(:foo, source)
end

Then /^the xml should be transformed into a properly mapped hash$/ do
  @translated_hash.should == {"doo"=>"d", "foo"=>{"bar"=>{"coo"=>"c"}}, "bar"=>{"boo"=>"b", "foo"=>"a"}}
end
