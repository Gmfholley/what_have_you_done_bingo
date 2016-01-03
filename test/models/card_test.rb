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
  
  
  
  test 'card should save with all variables needed' do
    a = Card.new(template: templates(:template_one), user: users(:susan))
    assert_not a.save, "Saved without a"
    b = Card.new(name: "myname")
    assert_not b.save, "Saved without an organization"
    b.organization = organizations(:factory)
    assert b.save, "Did not save with an organization and a factory"
  end

  
  test 'template should generate a token after creation' do
    a = Template.create(name: "test", organization: organizations(:factory))
    assert_not a.token.nil?, "Created a record but did not generate a token"
  end

end
