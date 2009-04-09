ENV["MAPPOO"] = "test"
require 'rubygems'
require 'spec'
require 'ruby-debug'
require File.expand_path(File.dirname(__FILE__) + "/../target_mapper")
require File.expand_path(File.dirname(__FILE__) + "/../mapping_direction")
require File.expand_path(File.dirname(__FILE__) + "/../factories")
require File.expand_path(File.dirname(__FILE__) + "/../path_translator")
require File.expand_path(File.dirname(__FILE__) + "/../xml_map")
require File.expand_path(File.dirname(__FILE__) + "/../hash_map")
require File.expand_path(File.dirname(__FILE__) + "/../mapper")

alias :running :lambda

[:get, :post, :action, :process].each do |action|
  eval %Q{
    def before_#{action}
      yield
      do_#{action}
    end
    alias during_#{action} before_#{action}
    def after_#{action}
      do_#{action}
      yield
    end
  }
end

