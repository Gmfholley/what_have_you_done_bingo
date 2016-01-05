# == Schema Information
#
# Table name: circles
#
#  id            :integer          not null, primary key
#  card_id       :integer
#  position_x    :integer
#  position_y    :integer
#  response      :string
#  question      :string
#  picture       :string
#  part_of_bingo :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'test_helper'

class CircleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "should create with a card, position x and y, question" do
    a = Circle.new(card: cards(:card_one), position_x: 0, position_y: 0)
    assert_not a.save, "Allowed it to save without a question"
    a = Circle.new(card: cards(:card_one), position_x: 0, question: "test")
    assert_not a.save, "Allowed it to save without a position_y"
    a = Circle.new(card: cards(:card_one), question: "test", position_y: 0)
    assert_not a.save, "Allowed it to save without a position_x"
    a = Circle.new(question: "test", position_x: 0, position_y: 0)
    assert_not a.save, "Allowed it to save without a card"
    a = Circle.new(card: cards(:card_one), position_x: 0, position_y: 0, question: "test")
    assert a.save, "Did not allow it to save with card, position x & y and test"
  end
  
  test "position x and y should be a number greater than zero" do 
    a = Circle.new(card: cards(:card_one), position_x: -1, position_y: 0, question: "test")
    assert_not a.save, "Allowed to save with a negative position_x"
    a = Circle.new(card: cards(:card_one), position_x: 0, position_y: -1, question: "test")
    assert_not a.save, "Allowed to save with a negative position_y"
    
  end
  
  test "defaults should be created for part of bingo" do
    a = Circle.new(card: cards(:card_one), position_x: -1, position_y: 0, question: "test")
    assert_equal a.part_of_bingo, false, "Part of bingo defaults to true"
  end
  
  ####################
  # Test methods
  ###################
  test "test marked should be true if response has anything in it" do
    a = Circle.new(card: cards(:card_one), position_x: -1, position_y: 0, question: "test")
    assert_equal a.marked?, false, "With no result, marked is true"
    a.response = "test"
    assert_equal a.marked?, true, "With a result, marked is not true"
  end
  
  test "should not allow a circle to have same card, x, and y values" do
    a = Circle.create(card: cards(:card_one), position_x: 2, position_y: 2, question: "test")
    b = Circle.new(card: cards(:card_one), position_x: 2, position_y: 2, question: "test")
    assert_not b.save, "Allowed duplicate to be created"
    b.position_x = 1
    assert b.save, "Did not allow different x, and y to be created"    
  end
    
  #####################
  # Test associations
  ###################
  test "should belong to card and have one user and template through card" do 
    a = circles(:one)
    assert_instance_of Card, a.card
    assert_instance_of User, a.user
    assert_instance_of Template, a.template
  end
  
  test "create CreateCircles interactor method that should build circles for a given card" do
    # Set up - create and save squares from a template
    template = templates(:template_two)
    squares = CreateSquares.work(template)
    template.squares.each do |s|
      s.question = "s"
      s.save
    end
    # marke one of them as having a free space - for convenience, make it the first one
    squares.first.update(free_space: true)
    
    # test the create circles method to see if circles are built for each square
    card = Card.create(template: template, user: users(:david))
    circles = CreateCircles.work(card)
    
    # test they create the right object
    assert_instance_of Circle, circles.first
    assert_equal circles.first.position_x, squares.first.position_x, "Should have copied over position x"
    assert_equal circles.first.position_y, squares.first.position_y, "Should have copied over position y"
    assert_equal circles.first.question, squares.first.question, "Should have copied over the question"
    assert_equal circles.first.marked?, true, "Should have marked circles from a square with a free space"
    assert_equal circles.last.marked?, false, "Showed circle as marked before it was marked"
    
    # test whether they have the info they need to be saved and are made in the proper amount
    assert_difference('Circle.count', template.squares.count) do
      circles.each do |c|
        c.save
      end
    end
  end
  
end
