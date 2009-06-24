=begin
require 'test_helper'

module Accounts
  class RoleTest < Test::Unit::TestCase
    
    context "A Role instance" do
    
      setup do
        @role = Factory.create(:role)
      end
    
      should_have_db_columns :id, :title, :content, :created_at, :updated_at
      should_validate_presence_of :title
      should_validate_uniqueness_of :title
      should_have_many :user_roles
      
    end
  end
end
=end