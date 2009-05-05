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
  when {:from => :hash, :to => :hash}
    Babelicious::Mapper.config(@tag.to_sym) do |m|
      m.direction = {:from => :hash, :to => :hash}

      m.map :from => "foo", :to => "zoo"
      m.map :from => "bar", :to => "yoo"
      m.map :from => "baz", :to => "too"
      m.map :from => "boo", :to => "soo/roo"
    end
  end
end

Given /^a mapping exists with nested nodes$/ do 
  Babelicious::Mapper.reset
  @direction = {:from => :xml, :to => :hash}
  @tag = :baz

  Babelicious::Mapper.config(@tag) do |m|
    m.direction = @direction

    m.map :from => "foo/bar", :to => "bar/foo"
    m.map :from => "foo/baz", :to => "bar/boo"
    m.map :from => "foo/cuk", :to => "foo/"
  end
end

Given /^a mapping exists with '(.*)' condition$/ do |condition|
  case condition
  when /unless/
    Babelicious::Mapper.config(:ignore) do |m|
      m.direction = {:from => :xml, :to => :hash}

      m.map :from => "foo/bar", :to => "bar/foo"
      m.map(:from => "foo/baz", :to => "bar/boo").unless(:empty)
    end
  when /when/
    Babelicious::Mapper.config(:when) do |m|
      m.direction = {:from => :xml, :to => :hash}

      m.map(:from => "foo/bar", :to => "bar/foo").when do |value|
        value =~ /hubba/
      end 
      m.map(:from => "foo/baz", :to => "bar/boo").when do |value|
        value =~ /bubba/
      end 
    end
  end
end

Given /^a mapping exists with concatenation$/ do
  Babelicious::Mapper.config(:concatenation) do |m|
    m.direction = {:from => :xml, :to => :hash}

    m.map :from => "foo/cuk", :to => "foo/bar", :concatenate => "|"
  end
end


#
##
###
When /^the mapping is translated$/ do
  case @direction
  when {:from => :xml, :to => :hash}
    xml = '<foo><bar>a</bar><baz>b</baz><cuk><coo>c</coo><doo>d</doo></cuk></foo>' 
    @translation = Babelicious::Mapper.translate(@tag.to_sym, xml)
  when {:from => :hash, :to => :xml}
    source = {:foo => {:bar => "a", :baz => "b", :cuk => {:coo => "c", :doo => "d"}}}
    @translation = Babelicious::Mapper.translate(@tag.to_sym, source)
  when {:from => :hash, :to => :hash}
    source = {:foo => "a", :bar => "b", :baz => "c", :boo => "d"}
    @translation = Babelicious::Mapper.translate(@tag.to_sym, source)
  end
end

When /^the mapping with '(.*)' nested nodes is translated$/ do |node_type|
  case node_type
  when /differently named/
    xml = '<foo><bar>a</bar><baz>b</baz><cuk><coo><id>c</id></coo><boo>d</boo></cuk></foo>' 
    @translation = Babelicious::Mapper.translate(@tag.to_sym, xml)
  when /similarly named/
    xml = '<foo><bar>a</bar><baz>b</baz><cuk><coo><id>c</id></coo><boo>d</boo><boo>e</boo></cuk></foo>' 
    @translation = Babelicious::Mapper.translate(@tag.to_sym, xml)
  when /partially empty/
    xml = '<foo><bar>a</bar><baz>b</baz><cuk><coo><id>c</id></coo><boo></boo></cuk></foo>' 
    @translation = Babelicious::Mapper.translate(@tag.to_sym, xml)
  when /identical/
    xml = '<foo><bar>a</bar><baz>b</baz><cuk><coo><id>c</id></coo><coo><id>d</id></coo></cuk></foo>' 
    @translation = Babelicious::Mapper.translate(@tag.to_sym, xml)
  end
end

When /^the '(.*)' mapping is translated$/ do |condition|
  case condition
  when /unless/
    xml = '<foo><bar>a</bar><baz></baz></foo>'
    @translation = Babelicious::Mapper.translate(:ignore, xml)
  when /when/
    xml = '<foo><bar>cuk</bar><baz>hubbabubba</baz></foo>'
    @translation = Babelicious::Mapper.translate(:when, xml)
  end
end

When /^the mapping with concatenation is translated$/ do
  xml = '<foo><bar>a</bar><baz>b</baz><cuk><coo>c</coo><coo>d</coo><coo>e</coo></cuk></foo>' 
  @translation = Babelicious::Mapper.translate(:concatenation, xml)
end


#
##
###
Then /^the xml should be correctly mapped$/ do
  case @direction
  when {:from => :xml, :to => :hash}
    @translation.should == {"doo"=>"d", "foo"=>{"bar"=>{"coo"=>"c"}}, "bar"=>{"boo"=>"b", "foo"=>"a"}}
  when {:from => :hash, :to => :xml}
    @translation.to_s.gsub(/\s/, '').should == '<?xmlversion="1.0"encoding="UTF-8"?><bar><foo>a</foo><boo>b</boo><cuk><coo>c</coo><doo>d</doo></cuk></bar>'    
  when {:from => :hash, :to => :hash}
    @translation.should == {"zoo" => "a", "yoo" => "b", "too" => "c", "soo" => {"roo" => "d"}}
  end
end

Then /^the xml should properly transform nested nodes for '(.*)'$/ do |node_type|
  case node_type
  when /differently named/
    @translation.should == {"foo"=>{"cuk" => {"boo" => "d", "coo" => {"id" => "c"}}}, "bar"=>{"boo"=>"b", "foo"=>"a"}}
  when /similarly named/
    @translation.should == {"foo"=>{"cuk" => {"boo" => ["d", "e"], "coo" => {"id" => "c"}}}, "bar"=>{"boo"=>"b", "foo"=>"a"}}
  when /partially empty/
    @translation.should == {"foo"=>{"cuk" => {"boo" => "", "coo" => {"id" => "c"}}}, "bar"=>{"boo"=>"b", "foo"=>"a"}}
  when /identical/
    @translation.should == {"foo"=>{"cuk" => {"coo" => [{"id" => "c"}, {"id" => "d"}]}}, "bar"=>{"boo"=>"b", "foo"=>"a"}}
  end
end 

Then /^the target should be correctly processed for condition '(.*)'$/ do |condition|
  case condition
  when /unless/
    @translation.should == {"bar" => {"foo" => "a"}}
  when /when/
    @translation.should == {"bar" => {"boo" => "hubbabubba"}}
  end 
end

Then /^the target should be properly concatenated$/ do
  @translation.should == {"foo"=>{"bar"=>"c|d|e"}}
end
