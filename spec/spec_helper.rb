require 'rubygems'
require 'spec'
$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'babel_icious'

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

