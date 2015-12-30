# == Schema Information
#
# Table name: templates
#
#  id              :integer          not null, primary key
#  size            :integer
#  organization_id :integer
#  name            :string
#  is_public       :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  token           :string
#  rating          :integer
#

require 'test_helper'

class TemplateTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  test 'template should not save without names or organizations' do
    a = Template.new(organization: organizations(:factory))
    assert_not a.save, "Saved without a name"
    b = Template.new(name: "myname")
    assert_not b.save, "Saved without an organization"
    b.organization = organizations(:factory)
    assert b.save, "Did not save with an organization and a factory"
  end
  
  test 'template should default to size 5 but size must be within 4-6' do
    a = Template.create(name: "test", organization: organizations(:factory))
    assert_equal a.size, 5, "Default size is not 5"
    assert a.update(size: 6), "Will not allow the size to be 6"
    assert a.update(size: 4), "will not allow the size to be 4"
    assert_not a.update(size: 3), "Allowed a size less than 4"
    assert_not a.update(size: 7), "Allowed an update greater than 6"
  end
  
  test 'template should be allowed a rating of easy, medium and hard (enum)' do
    a = Template.create(name: "test", organization: organizations(:factory))
    assert a.update!(ratings: :easy), "Did not allow rating to be easy"
    assert a.update(rating: :medium), "Did not allow rating to be medium"
    assert a.update(rating: :hard), "Did not allow rating to be hard"
    assert_not a.update(rating: :some_other_thing), "Allowed an update of rating to any random thing"
  end
  
  test 'template should default is_public to false' do
    a = Template.new(name: "test", organization: organizations(:factory))
    assert_equal a.is_public, false, "Default is set to true"
    assert a.update(is_public: true), "Not able to update is_public attribute"
  end
  
  test 'template should generate a token after creation' do
    a = Template.create(name: "test", organization: organizations(:factory))
    assert_not a.token.nil?, "Created a record but did not generate a token"
  end
  
  ############## 
  # Test Active Record Associations
  #################
  
  test 'template should belong to an organization' do
    assert_instance_of Template, organizations(:factory).templates.first, "Has_many relationship does not exist"
  end
  
end
