# == Schema Information
#
# Table name: squares
#
#  id          :integer          not null, primary key
#  position_x  :integer
#  position_y  :integer
#  picture     :string
#  question    :string
#  free_space  :boolean
#  template_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class SquareTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  test 'should be able to creates new square object with position, question, and template' do
    a = Square.create(position_x: 3, position_y: 3, question: "test", template: templates(:template_one))
    assert a.id, "Did not create a new square"
  end
  
  test 'should not create without a template' do
    a = Square.create(position_x: 3, position_y: 3, question: "test")
    assert a.id.nil?, "Saved without a template"
  end

  test 'should not create without a position_x' do
    a = Square.create(template: templates(:template_one), position_y: 3, question: "test")
    assert a.id.nil?, "Saved without a position_x"
  end

  test 'should not create without a position_y' do
    a = Square.create(position_x: 3, template: templates(:template_one), question: "test")
    assert a.id.nil?, "Saved without a position_y"
  end

  test 'should not create without a question' do
    a = Square.create(position_x: 3, position_y: 3, template: templates(:template_one))
    assert a.id.nil?, "Saved without a question"
  end
  
  test 'free space defaults to false and should be able to be updated' do
    a = Square.create(position_x: 3, position_y: 3, question: "test", template: templates(:template_one))
    assert_equal a.free_space, false, "Defaults to free space of false"
    assert a.update(free_space: true), "Did not allow the free space to be updated"  
  end
  
  test 'position_x and position_y should be between 0 and template.size - 1' do 
    a = squares(:one)
    assert_not a.update(position_x: -1), "Was able to update position_x to -1"
    assert_not a.update(position_x: 25), "Was able to update position x to 25 with limit of 0 to 24"
    assert_not a.update(position_y: -1), "Was able to update position_x to -1"
    assert_not a.update(position_y: 25), "Was able to update position x to 25 with limit of 0 to 24"
    assert a.update(position_x: 2, position_y: 2), "Was not able to update x and y to 2"
  end
  
  test "assert unique index of template, position x, and position y " do
    a = squares(:one)
    assert_not a.update(position_x: 1, position_y: 1)
    assert a.errors.full_messages, "test"
  end
  
  ###########################
  # Test associations
  ###########################
  test 'square belongs to template' do
    @square = squares(:one)
    assert_instance_of Template, @square.template, "Relationship does not exist"
  end
  
  
  
end
