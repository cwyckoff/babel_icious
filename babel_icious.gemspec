spec = Gem::Specification.new do |s|
  s.name = 'babel_icious'
  s.version = '0.0.1'
  s.date = '2009-04-13'
  s.summary = 'Babel_icious dynamic and scalable mapping tool'
  s.email = "github@cwyckoff.com"
  s.homepage = "http://github.com/cwyckoff/babel_icious"
  s.description = 'Babel_icious dynamic and scalable mapping tool'
  s.has_rdoc = true
  s.rdoc_options = ["--line-numbers", "--inline-source", "--main", "README.rdoc", "--title", "Babel_icious - A Mapping Tool for the Ages"]
  s.extra_rdoc_files = ["README.rdoc", "MIT-LICENSE"]
  s.authors = ["Chris Wyckoff"]
  s.add_dependency('libxml-ruby')
  
  s.files = (Dir['{README,{lib,spec}/**/*.{rdoc,json,rb,txt,xml,yml}}'])
end
 