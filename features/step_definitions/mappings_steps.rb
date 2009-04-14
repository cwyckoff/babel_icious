Given /^a mapping exists for '(.*)'$/ do |direction|
  @direction = direction
  
  case @direction
  when "xml to hash"
    Babelicious::Mapper.config(:foo) do |m|
      m.direction = {:from => :xml, :to => :hash}

      m.map :from => "foo/bar", :to => "bar/foo"
      m.map :from => "foo/baz", :to => "bar/boo"
      m.map :from => "foo/cuk/coo", :to => "foo/bar/coo"
      m.map :from => "foo/cuk/doo", :to => "doo"
    end
  when "hash to xml"
    Babelicious::Mapper.config(:bar) do |m|
      m.direction = {:from => :hash, :to => :xml}

      m.map :from => "foo/bar", :to => "bar/foo"
      m.map :from => "foo/baz", :to => "bar/boo"
      m.map :from => "foo/cuk/coo", :to => "bar/cuk/coo"
      m.map :from => "foo/cuk/doo", :to => "bar/cuk/doo"
    end
  end
end

When /^the mapping is translated$/ do
  case @direction
  when "xml to hash"
    xml = '<foo><bar>a</bar><baz>b</baz><cuk><coo>c</coo><doo>d</doo></cuk></foo>' 
    source = XML::Document.string(xml)
    @translated_hash = Babelicious::Mapper.translate(:foo, source)
  when "hash to xml"
    source = {:foo => {:bar => "a", :baz => "b", :cuk => {:coo => "c", :doo => "d"}}}
    @translated_xml = Babelicious::Mapper.translate(:bar, source)
  end
end

Then /^the xml should be transformed into a properly mapped hash$/ do
  @translated_hash.should == {"doo"=>"d", "foo"=>{"bar"=>{"coo"=>"c"}}, "bar"=>{"boo"=>"b", "foo"=>"a"}}
end

Then /^the hash should be transformed into a properly mapped xml string$/ do
  @translated_xml.to_s.gsub(/\s/, '').should == '<?xmlversion="1.0"encoding="UTF-8"?><bar><foo>a</foo><boo>b</boo><cuk><coo>c</coo><doo>d</doo></cuk></bar>'
end

