begin
  require 'rubygems'
  require 'test/unit'
  gem 'sqlite3-ruby'
  require 'active_record'
  require 'active_support'
  require 'models'
  
  #%w{ role user_role }.each do |m|
  #  require File.join(File.dirname(__FILE__), %w{ .. app models accounts }, "#{m}.rb")
  #end
  
  gem 'thoughtbot-shoulda'
  require 'shoulda'
  gem 'thoughtbot-factory_girl'
  require 'factory_girl'
  require 'mocha'
  require 'shoulda/rails'
rescue
  puts "Problem requiring dependencies in test helper [#{$!}]"
end
