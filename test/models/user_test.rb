# == Schema Information
#
# Table name: users
#
#  id                              :integer          not null, primary key
#  email                           :string           not null
#  crypted_password                :string
#  salt                            :string
#  created_at                      :datetime
#  updated_at                      :datetime
#  remember_me_token               :string
#  remember_me_token_expires_at    :datetime
#  reset_password_token            :string
#  reset_password_token_expires_at :datetime
#  reset_password_email_sent_at    :datetime
#  first_name                      :string
#  last_name                       :string
#  profile_picture                 :string
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_remember_me_token     (remember_me_token)
#  index_users_on_reset_password_token  (reset_password_token)
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  ########################
  # Test Field Validations
  ########################
  test 'users should not save without email' do
    a = User.create(first_name: "test", last_name: "test", password: "test5", password_confirmation: "test5")
    assert a.id.nil?, "Saved without email"
  end
  
  test 'users should not save without first name' do
    a = User.create(email: "test@email.com", last_name: "test", password: "test5", password_confirmation: "test5")
    assert a.id.nil?, "Saved without first name"
  end
  
  test 'users should not save without last name' do
    a = User.create(email: "test@email.com", first_name: "test", password: "test5", password_confirmation: "test5")
    assert a.id.nil?, "Saved without last name"
  end
  
  test 'users should not save without password' do
    a = User.create(email: "test@email.com", first_name: "test", last_name: "test", password_confirmation: "test5")
    assert a.id.nil?, "Saved without password"
  end
  
  test 'users should not save without password confirmation' do
    a = User.create(email: "test@email.com", first_name: "test", last_name: "test", password: "test5")
    assert a.id.nil?, "Saved without password confirmation"
  end  
  
  test 'users should not save without password of at least 5' do
    a = User.create(email: "test@email.com", first_name: "test", last_name: "test", password: "test", password_confirmation: "test")
    assert a.id.nil?, "Saved without password length of at least 5"
  end
  
  test 'users should not save if password confirmation does not match password' do
    a = User.create(email: "test@email.com", first_name: "test", last_name: "test", password: "test5", password_confirmation: "test6")
    assert a.id.nil?, "Saved without password and password confirmation matching"
  end
  
  test 'users should not save without a valid email (t@t.tt)' do
    a = User.create(email: "test@email", first_name: "test", last_name: "test", password: "test5", password_confirmation: "test5")
    if a.id.nil?
      a.email = "@email.co"
      a.save
    end
    if a.id.nil?
      a.email = "test.tt"
      a.save
    end
    assert a.id.nil?, "Saved with an invalid email"
  end
  
  test 'users should save with email (valid), first and last name, password, and password confirmation(5 characters or longer)' do
    a = User.create(email: "email@address.com", first_name: "test", last_name: "test", password: "test5", password_confirmation: "test5")
    assert_not a.id.nil?, "Failed to save with email"
  end
  
  ###############################
  # Test callbacks on creation
  ################################
  test 'password should be saved as encrypted hash' do
    a = User.create(email: "email@address.com", first_name: "test", last_name: "test", password: "test5", password_confirmation: "test5")
    assert_not a.crypted_password.nil?, "Did not encrypt the password"
  end
  
  # ################################
  # # Test active record relationships
  # ################################
  test 'users should have many organization_users' do
    assert_instance_of OrganizationUser, users(:susan).organization_users.first, "Has_many relationship does not exist"
  end
  
  test 'users should have many organizations' do
    assert_instance_of Organization, users(:susan).organizations.first, "Has_many relationship does not exist"
  end
  
  # ##############################
  # # Test role method of user
  # ###############################
  test '.role method of a user should return their role for an organization' do 
    # susan is the admin of the bank
    @user = users(:susan)
    @organization = organizations(:bank)
    assert_equal @user.role(@organization), Role.admin, "Susan is not an admin of the bank"
   
    # susan is not a member of the factory
    @organization = organizations(:factory)
    assert_equal @user.role(@organization), nil, "Susan is somehow a member of the factory"
    
    # david is a user of the factory
    @user = users(:david)
    assert_equal @user.role(@organization), Role.user, "David is not a user of the factory"
    
  end

  
  # test 'user should belong to organization' do
  #   assert_instance_of Organization, users(:susan).organization, "Belongs_to relationship between user and organization does not exist"
  # end
  #
  # test 'user should belong to role' do
  #   assert_instance_of Role, users(:susan).role, "Belongs_to relationship between user and role does not exist"
  # end
  
end
