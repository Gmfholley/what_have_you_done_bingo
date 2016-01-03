class CreateSquares
  # intended to work with the Template class
  
  # for a template, it will build all the square needed, with the appropriate x, y positions
  # returns an array of Square objects
  #
  # template = Template objects
  #
  # returns an array of Square objects
  def self.work(template=Template.new)
    (0...template.size).each do |x|
      (0...template.size).each do |y|
        template.squares.build(position_x: x, position_y: y)        
      end
    end
    template.squares
  end
  
end