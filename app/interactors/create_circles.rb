class CreateCircles
  # intended to work with the Template class
  
  # for a card, it will build all the circles needed, with the appropriate x, y positions
  # returns an array of Circle objects
  #
  # card = Card object
  #
  # returns an array of Circle objects
  def self.work(card)
    card.template.squares.each do |square|
      a = card.circles.build(position_x: square.position_x, position_y: square.position_y, question: square.question)
      if square.free_space
        a.response = "free space"
      end
    end
    card.circles
  end
  
end