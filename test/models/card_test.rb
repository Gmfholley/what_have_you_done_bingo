# == Schema Information
#
# Table name: cards
#
#  id          :integer          not null, primary key
#  template_id :integer
#  user_id     :integer
#  token       :string
#  is_public   :boolean
#  num_bingos  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_cards_on_token  (token)
#

require 'test_helper'

class CardTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
    
  test 'card not should save without all variables needed' do
    a = Card.new(template: templates(:template_one))
    assert_not a.save, "Saved without a user"
    b = Card.new(user: users(:susan))
    assert_not b.save, "Saved without a template"
    b.template = templates(:template_one)
    assert b.save, "Did not save with an template and a user"
  end

  test 'number of bingos should be greater than 0' do
    a = Card.new(template: templates(:template_one), user: users(:susan))
    a.num_bingos = -1
    assert_not a.save, "Saved with a negative number of bingos"
    a.num_bingos = "Yes"
    assert_not a.save, "Saved number of bingos as a string"
    a.num_bingos = 0
    assert a.save, "Did not save when number of bingos is set to zero"
  end
  
  test 'template should generate a token after creation' do
    a = Template.create(name: "test", organization: organizations(:factory))
    assert_not a.token.nil?, "Created a record but did not generate a token"
  end
  
  test 'should set defaults' do 
    a = Card.new
    assert_equal false, a.is_public, "Did not set is public to false"
    assert_equal 0, a.num_bingos, "Did not set number of bingos to zero"
  end
  
  #####################
  # Test associations
  ###################
  test 'should have associations to user and template' do
    a = cards(:card_one)
    assert_instance_of User, a.user, "Does not have a user"
    assert_instance_of Template, a.template, "Does not have a template"
  end

end
