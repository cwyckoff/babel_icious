spec = Gem::Specification.new do |s|
  s.name = 'babel_icious'
  s.version = '0.0.4'
  s.date = '2009-04-24'
  s.summary = 'Babel_icious dynamic and scalable mapping tool'
  s.email = "github@cwyckoff.com"
  s.homepage = "http://github.com/cwyckoff/babel_icious"
  s.description = 'Babel_icious dynamic and scalable mapping tool'
  s.has_rdoc = true
  s.rdoc_options = ["--line-numbers", "--inline-source", "--main", "README.rdoc", "--title", "Babel_icious - A Mapping Tool for the Ages"]
  s.extra_rdoc_files = ["README.rdoc", "MIT-LICENSE"]
  s.authors = ["Chris Wyckoff"]
  s.add_dependency('libxml-ruby')
  
  s.files = ["init.rb",
	     "lib/babel_icious.rb",
             "lib/babel_icious/hash_map.rb",
             "lib/babel_icious/map_factory.rb",
             "lib/babel_icious/xml_map.rb",
             "lib/babel_icious/mapper.rb",
             "lib/babel_icious/path_translator.rb",
             "lib/babel_icious/target_mapper.rb",
             "lib/babel_icious/core_ext/enumerable.rb"]
end
 
