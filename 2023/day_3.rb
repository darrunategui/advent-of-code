require '../input_reader'
require '../coordinate'
input = InputReader.read

class Schematic
  attr_accessor :digit_coords, :symbol_coords, :part_num_coords, :gear_ratio_num_coords
  def initialize(input)
    @digit_coords = Set.new
    @symbol_coords = Set.new

    @grid = input.split("\n").map(&:chars)
    for x in (0...@grid.length)
      working_range = []
      for y in (0...@grid[x].length)
        coord = Coordinate.new(x,y)
        if @grid[x][y].match?(/\d/)
          if working_range.empty? # found first digit
            working_range << coord
          end
          if y+1 == @grid[x].length || !@grid[x][y+1].match?(/\d/) #found last digit
            working_range << coord
            digit_coords << working_range
            working_range = []
          end
        elsif @grid[x][y].match?(/\./)
          next
        else
          symbol_coords << coord
        end
      end
    end

    @part_num_coords = Set.new
    @gear_ratio_num_coords = Set.new
    symbol_coords.each { |symbol_coord|
      is_gear = @grid[symbol_coord.x][symbol_coord.y] == "*"
      found_part_nums = Set.new
      [[-1,-1], [-1,0], [-1, 1], [0, 1], [1,1], [1,0], [1,-1], [0,-1]].map { |m| 
        to_check = Coordinate.new(symbol_coord.x + m[0], symbol_coord.y + m[1])

        digit_coords.each { |range|
          if range.first.x == to_check.x && range.first.y <= to_check.y && to_check.y <= range.last.y
            part_num_coords << range
            found_part_nums << range
          end
        }
      }

      if is_gear && found_part_nums.length == 2
        gear_ratio_num_coords << found_part_nums.to_a[0]
        gear_ratio_num_coords << found_part_nums.to_a[1]
      end
    }
  end

  def part_numbers
    part_num_coords.map { |range|
      x = range.first.x
      (range.first.y..range.last.y).map { |y| @grid[x][y] }.join.to_i
    }
  end

  def gear_ratios
    gear_ratio_num_coords.map { |range|
      x = range.first.x
      (range.first.y..range.last.y).map { |y| @grid[x][y] }.join.to_i
    }
  end
end

schematic = Schematic.new(input)
p schematic.part_numbers.sum

p schematic.gear_ratios.each_slice(2).map { |g| g.reduce(1, :*) }.sum
