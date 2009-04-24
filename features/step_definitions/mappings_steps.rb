Given /^a mapping exists for '(.*)' to '(.*)' with tag '(.*)'$/ do |source, target, mapping_tag|
  @direction = {:from => source.to_sym, :to => target.to_sym}
  @tag = mapping_tag
  
  case @direction
  when {:from => :xml, :to => :hash}
    Babelicious::Mapper.config(@tag.to_sym) do |m|
      m.direction = {:from => :xml, :to => :hash}

      m.map :from => "foo/bar", :to => "bar/foo"
      m.map :from => "foo/baz", :to => "bar/boo"
      m.map :from => "foo/cuk/coo", :to => "foo/bar/coo"
      m.map :from => "foo/cuk/doo", :to => "doo"
    end
  when {:from => :hash, :to => :xml}
    Babelicious::Mapper.config(@tag.to_sym) do |m|
      m.direction = {:from => :hash, :to => :xml}

      m.map :from => "foo/bar", :to => "bar/foo"
      m.map :from => "foo/baz", :to => "bar/boo"
      m.map :from => "foo/cuk/coo", :to => "bar/cuk/coo"
      m.map :from => "foo/cuk/doo", :to => "bar/cuk/doo"
    end
  end
end

Given /^a mapping exists with concatenation$/ do
  Babelicious::Mapper.config(:concatenation) do |m|
    m.direction = {:from => :xml, :to => :hash}

    m.map :from => "foo/cuk", :to => "foo/bar", :concatenate => "|"
  end
end

Given /^a mapping exists with identical nested nodes$/ do 
  @direction = {:from => :xml, :to => :hash}
  @tag = :baz

  Babelicious::Mapper.config(@tag) do |m|
    m.direction = @direction

    m.map :from => "foo/bar", :to => "bar/foo"
    m.map :from => "foo/baz", :to => "bar/boo"
    m.map :from => "foo/cuk", :to => "foo/"
  end
end

When /^the mapping is translated$/ do
  case @direction
  when {:from => :xml, :to => :hash}
    xml = '<foo><bar>a</bar><baz>b</baz><cuk><coo>c</coo><doo>d</doo></cuk></foo>' 
    @translation = Babelicious::Mapper.translate(@tag.to_sym, xml)
  when {:from => :hash, :to => :xml}
    source = {:foo => {:bar => "a", :baz => "b", :cuk => {:coo => "c", :doo => "d"}}}
    @translation = Babelicious::Mapper.translate(@tag.to_sym, source)
  end
end

When /^the mapping with nested nodes is translated$/ do 
  xml = '<foo><bar>a</bar><baz>b</baz><cuk><coo><id>c</id></coo><coo><id>d</id></coo></cuk></foo>' 
  @translation = Babelicious::Mapper.translate(@tag.to_sym, xml)
end

When /^the concatenated mapping is translated$/ do
  xml = '<foo><bar>a</bar><baz>b</baz><cuk><coo>c</coo><coo>d</coo><coo>e</coo></cuk></foo>' 
  @translation = Babelicious::Mapper.translate(:concatenation, xml)
end

Then /^the xml should be correctly mapped$/ do
  case @direction
  when {:from => :xml, :to => :hash}
    @translation.should == {"doo"=>"d", "foo"=>{"bar"=>{"coo"=>"c"}}, "bar"=>{"boo"=>"b", "foo"=>"a"}}
  when {:from => :hash, :to => :xml}
    @translation.to_s.gsub(/\s/, '').should == '<?xmlversion="1.0"encoding="UTF-8"?><bar><foo>a</foo><boo>b</boo><cuk><coo>c</coo><doo>d</doo></cuk></bar>'    
  end
end

Then /^the xml should properly transform nested nodes$/ do
  @translation.should == {"foo"=>{"cuk" => {"coo" => [{"id" => "c"}, {"id" => "d"}]}}, "bar"=>{"boo"=>"b", "foo"=>"a"}}
end 

Then /^the xml should properly concatenate node content$/ do
  @translation.should == {"foo"=>{"bar"=>{"cuk"=>"c|d|e"}}}
end 
