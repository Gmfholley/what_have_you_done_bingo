class CheckBingo
  # intended to work with the Card class
  
  # for a card, it will check if its collection of circles have any circles, mark the circles if part of a bingo, and return the number of bingos
  # returns an array of Square objects
  #
  # card = Card objects
  #
  # returns number of bingos  
  attr_reader :card, :size, :circles, :horizontal, :vertical, :left_x, :right_x, :num_bingos
  
  def initialize(card)
    @card = card
    @size = card.template.size
    @circles = card.circles.sort { |a,b| [a.position_x, a.position_y] <=> [b.position_x,
b.position_y] }
    @horizontal = Hash.new(0)
    @vertical = Hash.new(0)
    @left_x = 0
    @right_x = 0
    @num_bingos = 0
  end
  
  # checks the card for bingos and returns the number
  #
  # returns an Integer
  def work
    check_marked_circles
    @card.update(num_bingos: get_num_bingos)
  end
  
  
  private
  # checks each circle to see if they are marked and starts tallying them into checks for bingos
  #
  # returns nothing
  def check_marked_circles  
    circles.each do |circle|
      if circle.marked?
        update_count_of_marked_circles(circle.position_x, circle.position_y)  
      end
    end
  end
    
  # calculates whether the tallies make it a bingo, mark the circles if they are part of a bingo, and keeps track of how many total bingos the card has
  #
  # returns an Integer
  def get_num_bingos
    check_and_mark_left_x
    check_and_mark_right_x
    check_horizontal_bingos
    check_vertical_bingos
    @num_bingos
  end
  
  # updates the count various tests (which should sum to zero)
  #
  # returns nothing
  def update_count_of_marked_circles(x, y)
    @vertical[x] += 1
    @horizontal[y] += 1
    if part_of_left_x?(x, y)
      @left_x += 1
    end
    if part_of_right_x?(x, y)
      @right_x += 1
    end
  end
  
  # checks to see if card has a left-x bingo
  #
  # returns nothing
  def check_and_mark_left_x
    if @left_x == size
      @num_bingos += 1
      circles.each do |circle|
        if part_of_left_x?(circle.position_x, circle.position_y)
          update_circle(circle)
        end
      end
    end
  end

  # checks to see if card has a right-x bingo
  #
  # returns nothing
  def check_and_mark_right_x
    if @right_x == size
      @num_bingos += 1
      circles.each do |circle|
        if part_of_right_x?(circle.position_x, circle.position_y)
          update_circle(circle)
        end
      end
    end
  end
  
  # checks to see if there are any vertical bingos (meaning all position_xs are the same)
  #
  # returns nothing
  def check_vertical_bingos
    @vertical.each do |k, v|
      if size == v
        @num_bingos += 1
        circles.each do |circle|
          if circle.position_x == k
            update_circle(circle)
          end
        end
      end
    end
  end
  
  # checks to see if there are any horizontal bingos (meaning all position_ys are the same)
  #
  # returns nothing=
  def check_horizontal_bingos
    @horizontal.each do |k, v|
      if size == v
        @num_bingos += 1
        circles.each do |circle|
          if circle.position_y == k
            update_circle(circle)
          end
        end
      end
    end
  end
  
  # updates the circle's part_of_bingo attribute to true
  #
  # circle - Circle object
  #
  # returns true
  def update_circle(circle)
    circle.update(part_of_bingo: true)
  end
  
  # check if these indexes are part of a left-most X bingo
  #
  # x - Integer
  # y - Integer
  #
  # returns boolean
  def part_of_left_x?(x, y)
    x == y
  end

  # check if these indexes are part of a left-most X bingo
  #
  # x - Integer
  # y - Integer
  #
  # returns boolean  
  # 
  # e.g.:  solutions with a size of 5
  #        (0, 4), (1, 3), (2, 2), (3, 1), (4, 0)
  #  --> true
  def part_of_right_x?(x, y)
    x == (size - y - 1)
  end
  
end