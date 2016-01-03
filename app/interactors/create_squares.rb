class CreateSquares

  
  def self.work(template=Template.new)
    (0...template.size).each do |x|
      (0...template.size).each do |y|
        template.squares.build(position_x: x, position_y: y)        
      end
    end
    template.squares
  end
  
end