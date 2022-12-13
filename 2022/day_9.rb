require 'set'
require '../input_reader'
require '../coordinate'
input = InputReader.read.split("\n").map { |l| { direction: l.split(' ')[0], steps: l.split(' ')[1].to_i } }

class Rope
  attr_reader :tail_history
  def initialize(knots)
    @knots = (1..knots).map { |_| Coordinate.new(0, 0) }
    @tail_history = Set.new
  end

  def head
    @knots.first
  end

  def head=(coord)
    @knots[0] = coord
  end

  def tail
    @knots.last
  end

  def step(direction)
    self.head = self.head.move(direction)

    for i in 0...@knots.length do
      if i+1 == @knots.length
        @tail_history << tail
        break
      elsif knots_too_far?(@knots[i], @knots[i+1])
        @knots[i+1] = slack_knot(@knots[i], @knots[i+1])
      end
    end
  end

  private

  def knots_too_far?(ahead, behind)
    (ahead.x - behind.x).abs > 1 || (ahead.y - behind.y).abs > 1
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

def walk(input, rope)
  input.each do |entry|
    for step in 1..entry[:steps] do
      rope.step(entry[:direction])
    end
  end
end

#part 1
rope = Rope.new(2)
walk(input, rope)
puts [*rope.tail_history, rope.tail].uniq { |c| [c.x, c.y] }.count

rope = Rope.new(10)
walk(input, rope)
puts [*rope.tail_history, rope.tail].uniq { |c| [c.x, c.y] }.count
