class CreateSquares
  
  attr_accessor :template
  
  def work
    [0..template.size] do |x|
      [0..template.size] do |y|
        template.squares.build(position_x: x, position_y: y)
      end
    end
    template
  end
  
end