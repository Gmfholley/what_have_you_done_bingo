# == Schema Information
#
# Table name: organizations
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  token      :string
#

require 'test_helper'

class OrganizationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  test 'organizations should not save without names' do
    a = Organization.new
    assert_not a.save
  end
  
  test 'organizations should save with names' do
    a = Organization.new(name: "test")
    assert a.save,  "Did not save with a name"
  end
  
  test 'organizations should generate a token after creation' do
    a = Organization.create(name: "test")
    assert_not a.token.nil?, "Created a record but did not generate a token"
  end
  
  test 'organization accepts nested attributes for user' do
    Organization.new(name: "test", users_attributes: {})
  end
  
  ############## 
  # Test Active Record Associations
  #################
  
  test 'organizations should have many organization_users' do
    assert_instance_of OrganizationUser, organizations(:factory).organization_users.first, "Has_many relationship does not exist"
  end
  
  test 'organizations should have many users' do
    assert_instance_of User, organizations(:factory).users.first, "Has_many relationship does not exist"
  end
  
  test 'organization should have many templates' do 
    assert_instance_of Template, organizations(:factory).templates.first, "Has_many relationship does not exist"
  end
  
end