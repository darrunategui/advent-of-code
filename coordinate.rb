class Coordinate
  attr_accessor :x, :y
  def initialize(x, y)
    @x = x
    @y = y
  end

  MOVES = { 'R' => [1,0], 'L' => [-1, 0], 'U' => [0,1], 'D' => [0,-1] }

  def move(direction)
    Coordinate.new(x + MOVES[direction][0], y + MOVES[direction][1])
  end

  def ==(other)
    eql?(other)
  end

  def eql?(other)
    other != nil && self.x == other.x && self.y == other.y
  end

  def hash
    [x, y].hash
  end

  def to_s
    "[#{x}, #{y}]" 
  end
end
