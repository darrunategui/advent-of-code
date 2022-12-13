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

  def find_path
    navigator = heights.keys.to_h { |c| [c, 0] }
    queue = [start]
    while (reference = queue.shift) != nil
      next_steps = valid_steps(reference)
      next_steps.each do |step|
        if navigator[step] == 0 || navigator[step] > navigator[reference]+1
          navigator[step] = navigator[reference] + 1
          queue << step
        end
      end
    end
    navigator[self.end] == 0 ? nil : navigator
  end
end

map = Map.new(InputReader.read)

# part 1
puts map.find_path[map.end]

# part 2
starting_points = map.heights.filter { |c, v| v == 'a' }.keys
puts starting_points.filter_map { |c|
  map.start = c
  map.find_path
}.map { |path| path[map.end] }.sort.first
