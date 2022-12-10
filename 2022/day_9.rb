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

  # def ==(other)
  #   self.x == other.x && self.y == other.y
  # end

  def to_s
    "[#{x}, #{y}]" 
  end
end

class Rope
  attr_reader :head, :tail, :head_history, :tail_history
  def initialize
    @start = Coordinate.new(0, 0)
    @head = Coordinate.new(0, 0)
    @tail = Coordinate.new(0, 0)
    @head_history = []
    @tail_history = []
  end

  def step(direction)
    @head_history << @head
    @head = @head.move(direction)
    if head_tail_too_far?
      @tail_history << @tail
      @tail = @head_history.last 
    end
  end

  private

  def head_tail_too_far?
    (@head.x - @tail.x).abs > 1 || (@head.y - @tail.y).abs > 1
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
