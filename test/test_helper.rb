require 'rubygems'
require 'active_support'
require 'active_support/test_case'
=begin
begin
  require 'rubygems'
  require 'test/unit'
  gem 'sqlite3-ruby'
  require 'active_record'
  require 'active_support'
  gem 'thoughtbot-shoulda'
  require 'shoulda'
  gem 'thoughtbot-factory_girl'
  require 'factory_girl'
  require 'mocha'
  require 'shoulda/rails'
  require 'test_helper'
  #%w{ link }.each do |m|
  #  require File.join(File.dirname(__FILE__), %w{ .. app models }, "#{m}.rb")
  #end
  
rescue
  puts "Problem requiring dependencies in test helper [#{$!}]"
end
=end
