# == Schema Information
#
# Table name: organization_users
#
#  id              :integer          not null, primary key
#  organization_id :integer
#  user_id         :integer
#  role_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'test_helper'

class OrganizationUserUserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  test 'organization_users should not save without a user' do
    a = OrganizationUser.new(organization: organizations(:factory), role: roles(:admin))
    assert_not a.save
  end
  
  test 'organization_users should not save without a role' do
    a = OrganizationUser.new(organization: organizations(:factory), user: users(:susan))
    assert_not a.save
  end
  
  test 'organization_users should not save without a organization' do
    a = OrganizationUser.new(user: users(:susan), role: roles(:admin))
    assert_not a.save
  end
  
  test 'organization_users should save with an organization, user, and role' do
    a = OrganizationUser.new(user: users(:susan), role: roles(:admin), organization: organizations(:factory))
    assert a.save,  "Did not save even though it should have"
  end
  
  test 'organization_users should have a unique organization and user combination' do
    a = OrganizationUser.create(user: users(:susan), role: roles(:admin), organization: organizations(:bank))
    assert_equal nil, a.id, "Created a record for susan-bank even though she already has one"
  end
  
end
