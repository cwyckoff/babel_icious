require 'rubygems'
require 'nokogiri'

$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__))) unless $LOAD_PATH.include?(File.expand_path(File.dirname(__FILE__)))

require "babel_icious/core_ext/enumerable"
require "babel_icious/core_ext/nokogiri_xml_node"
require "babel_icious/map_rule"
require "babel_icious/map_definition"
require "babel_icious/map_factory"
require "babel_icious/path_translator"
require "babel_icious/mappers/base_map"
require "babel_icious/mappers/xml_map"
require "babel_icious/mappers/hash_map"
require "babel_icious/mappers/object_map"
require "babel_icious/mapper"
require "babel_icious/map_condition"

