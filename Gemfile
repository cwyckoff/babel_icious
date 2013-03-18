source 'http://gems.lmpcloud.com'
source 'https://rubygems.org'

gem 'rake',               '0.8.7'
gem 'andand',             '1.3.1'
gem 'nokogiri',           '1.4.4'

def ruby_1_8?
  major, minor, teeny = RUBY_VERSION.split(".")
  "1" == major && "8" == minor
end

group :development do
  if ruby_1_8?
    gem 'ruby-debug'
  else
    gem 'debugger'
  end
end

group :test do
  gem 'cucumber',           '1.2.2',  :require => false
  gem 'fixjour',            '0.5.1',  :require => false
  gem 'rspec',              '~> 2.5.0'
  gem 'rspec-core',         '~> 2.5.0'
  gem 'rspec-expectations', '~> 2.5.0'
  gem 'rspec-mocks',        '~> 2.5.0'
end
