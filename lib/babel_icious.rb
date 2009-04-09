require 'rubygems'
require 'xml'

$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__))) unless $LOAD_PATH.include?(File.expand_path(File.dirname(__FILE__)))

require "babel_icious/target_mapper"
require "babel_icious/factories"
require "babel_icious/path_translator"
require "babel_icious/xml_map"
require "babel_icious/hash_map"
require "babel_icious/mapper"
