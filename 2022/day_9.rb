require '../input_reader'
input = InputReader.read.split("\n").map { |l| { direction: l.split(' ')[0], steps: l.split(' ')[1].to_i } }

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

  def to_s
    "[#{x}, #{y}]" 
  end
end

class Rope
  attr_reader :head, :tail, :tail_history
  def initialize
    @head = Coordinate.new(0, 0)
    @tail = Coordinate.new(0, 0)
    @tail_history = []
  end

  def step(direction)
    @head = @head.move(direction)
    if knots_too_far?
      @tail_history << @tail
      @tail = slack_knot(@head, @tail)
    end
  end

  private

  def knots_too_far?
    (@head.x - @tail.x).abs > 1 || (@head.y - @tail.y).abs > 1
  end

  def slack_knot(ahead, behind)
    diff = [ahead.x - behind.x, ahead.y - behind.y]
    case diff
    when [2, 0] then behind.move('R')
    when [-2, 0] then behind.move('L')
    when [0, 2] then behind.move('U')
    when [0, -2] then behind.move('D')
    else
      if ahead.x > behind.x && ahead.y > behind.y
        behind.move('R').move('U')
      elsif ahead.x > behind.x && ahead.y < behind.y
        behind.move('R').move('D')
      elsif ahead.x < behind.x && ahead.y > behind.y
        behind.move('L').move('U')
      else
        behind.move('L').move('D')
      end
    end
  end
end

rope = Rope.new
#part 1
input.each do |entry|
  for step in 1..entry[:steps] do
    rope.step(entry[:direction])
  end
end

puts [*rope.tail_history, rope.tail].uniq { |c| [c.x, c.y] }.count
# 6563
