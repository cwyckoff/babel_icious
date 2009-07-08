require 'rubygems'
require 'ruby-debug'
require 'babel_icious'
require File.expand_path(File.dirname(__FILE__) + "/../market/lib/event_api/mappings/events.rb")
 
# task :default => [:]

namespace :mappings do
  
  desc "iterate through all babel_icious definitions and spit out mapping rules"
  task :all do
    Babelicious::Mapper.definitions.each do |key, definition|
      puts "Map definition: '#{key.to_s}'\n\n"
      len = definition.rules.map { |r| r.source_path.length }.max
      definition.rules.each do |rule|
        puts "\t%-#{len}s => %s" % [rule.source_path, rule.target_path]
      end 
      puts "\n\n"
    end 
  end

  desc "iterate through a specific map definition and spit out mapping rules"
  task :definition, :def_key do |t, def_key|
    key = def_key[:def_key]
    definition = Babelicious::Mapper.definitions[key.to_sym]
    puts "Map definition: '#{key.to_s}'\n\n"
    len = definition.rules.map { |r| r.source_path.length }.max
    definition.rules.each do |rule|
      puts "\t%-#{len}s => %s" % [rule.source_path, rule.target_path]
    end 
    puts "\n\n"
  end

  desc "list all map definition keys"
  task :keys do
    puts "Babelicious map definition keys:\n\n"
    Babelicious::Mapper.definitions.each do |key, definition|
      puts "#{key}\n"
    end 
  end

end


