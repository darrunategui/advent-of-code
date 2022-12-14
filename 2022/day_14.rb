require '../input_reader'
require '../coordinate'
require 'set'

def rock_paths(input)
  input.split("\n").map { |l|
    coords = l.split(' -> ').map { |c| 
      Coordinate.new(c.split(',').first.to_i, c.split(',').last.to_i)
    }
    coords_set = Set.new

    coords.each_cons(2).each do |point_1, point_2|
      axis_change = point_1.x == point_2.x ? :y : :x
      ordered = [point_1, point_2].sort_by(&axis_change)
      for value in (ordered.first.send(axis_change)..ordered.last.send(axis_change))
        coords_set.add(Coordinate.new(
          axis_change == :y ? point_1.x : value,
          axis_change == :x ? point_1.y : value,
        ))
      end
    end
    coords_set
  }.reduce(:|)
end

def pour(taken_coords, sand, max_y)
  loop do
    break if sand.y == max_y
    
    next_coord = sand.move('U')

    if !taken_coords.include?(next_coord)
      sand = next_coord
    elsif !taken_coords.include?(next_coord.move('L'))
      sand = next_coord.move('L')
    elsif !taken_coords.include?(next_coord.move('R'))
      sand = next_coord.move('R')
    else
      break
    end
  end
  sand.y == max_y ? nil : sand
end

def simulate(rocks)
  sand_source = Coordinate.new(500, 0)

  max_y = rocks.map { |c| c.y }.max
  rock_and_sand = rocks.dup
  count = 0
  loop do
    count = count + 1
    landing_spot = pour(rock_and_sand, sand_source, max_y)
    break if landing_spot.nil?

    rock_and_sand.add(landing_spot)
    break if landing_spot == sand_source
  end 
  count
end

# part 1
part_1_rocks = rock_paths(InputReader.read).freeze
p simulate(part_1_rocks)

# part 2
floor_y = part_1_rocks.map { |c| c.y }.max + 2
floor_input = "#{500 - floor_y - 2}, #{floor_y} -> #{500 + floor_y + 2}, #{floor_y}"
part_2_rocks = part_1_rocks | rock_paths(floor_input)
p simulate(part_2_rocks)
