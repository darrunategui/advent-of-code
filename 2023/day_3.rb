require '../input_reader'
require '../coordinate'
input = InputReader.read

class Schematic
  attr_accessor :digit_coords, :symbol_coords
  def initialize(input)
    @digit_coords = []
    @symbol_coords = Set.new

    grid = input.split("\n").map(&:chars)
    @grid = grid
    for x in (0...grid.length)
      digit_coords = []
      for y in (0...grid[x].length)
        coord = Coordinate.new(x,y)
        if grid[x][y].match?(/\d/)
          if digit_coords.empty? # found first digit
            digit_coords << coord
          elsif y+1 == grid[x].length || !grid[x][y+1].match?(/\d/) #found last digit
            digit_coords << coord
            digit_coords << digit_coords
            digit_coords = []
          else # middle of digit
            next
          end
        elsif grid[x][y].match?(/\./)
          next
        else
          symbol_coords << coord
        end
      end
    end
  end

  def digit_nums
    digit_coords.map { |range|
      x = range.first.x
      (range.first.y..range.last.y).map { |y| @grid[x][y] }.join.to_i
    }
  end
end

schematic = Schematic.new(input)
p schematic.digit_coords

real_part_nums = Set.new
schematic.symbol_coords.each { |symbol_coord|
  [[-1,-1], [-1,0], [-1, 1], [0, 1], [1,1], [1,0], [1,-1], [0,-1]].map { |m| 
    Coordinate.new(symbol_coord.x + m[0], symbol_coord.y + m[1])
  }
  schematic.digit_coords { |range|
    # :( unfinished
  }
}
