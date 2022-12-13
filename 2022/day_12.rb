require '../input_reader'
require '../coordinate'
input = InputReader.read.split("\n")

class Map
  attr_accessor :start, :end, :heights
  def initialize(input)
    @heights = {}
    grid = input.split("\n").map(&:chars)
    for x in (0...grid.length)
      for y in (0...grid[x].length)
        coord = Coordinate.new(x,y)
        @start = coord if grid[x][y] == 'S'
        @end = coord if grid[x][y] == 'E'
        @heights[coord] = case coord
        when @start then 'a'
        when @end then 'z'
        else grid[x][y]
        end
      end
    end
  end

  def in_bounds?(coord)
    heights.key?(coord)
  end

  def valid_steps(reference)
    surrounding_coords = Coordinate::MOVES.keys.
      map { |m| reference.move(m) }.
      filter { |c|
        in_bounds?(c) && 
        c != start && 
        (heights[c].ord - heights[reference].ord <= 1)
      }
  end
end

map = Map.new(InputReader.read)
navigator = map.heights.keys.to_h { |c| [c, 0] }

shortest_path = nil
queue = [map.start]
while (reference = queue.shift) != nil
  next_steps = map.valid_steps(reference)
  next_steps.each do |step|
    if navigator[step] == 0 || navigator[step] > navigator[reference]+1
      navigator[step] = navigator[reference] + 1
      queue << step
      shortest_path = navigator[step] if step == map.end
    end
  end

  break if !shortest_path.nil?
end

puts shortest_path
#puts navigator.
#  values.map { |p| '%02d' % p }.each_slice(8).
#  map { |s| s.join(' ') }.
#  join("\n")
