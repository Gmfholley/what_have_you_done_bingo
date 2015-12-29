# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'test_helper'

class RoleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  test 'roles should not save without names' do
    a = Role.new
    assert_not a.save, "Saved without a name"
  end
  
  test 'roles should save with names' do
    a = Role.new(name: "test")
    assert a.save,  "Did not save with a name"
  end
  
  test 'roles should have many organization_users' do
    assert_instance_of OrganizationUser, roles(:admin).organization_users.first, "Has_many relationship does not exist"
  end
  
  test 'Role.admin should return an integer or nil if not found' do
    assert Role.admin, "Method does not appear to be called"
  end
  
  test 'Role.user_id should return an integer or nil if not found' do
    assert Role.admin, "Method does not appear to be called"
  end
  
end
