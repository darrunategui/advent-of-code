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

def pour(taken_coords, sand)
  max_y = taken_coords.map { |c| c.y }.max

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

sand_source = Coordinate.new(500, 0).freeze
rocks = rock_paths(InputReader.read).freeze

# part 1
rock_and_sand = rocks.dup
loop do
  landing_spot = pour(rock_and_sand, sand_source)
  break if landing_spot.nil?

  rock_and_sand.add(landing_spot)
end 

puts (rock_and_sand - rocks).length


# part 2
rock_and_sand = rocks.dup
floor_y = rocks.map { |c| c.y }.max + 2
floor_input = "#{500 - floor_y - 2}, #{floor_y} -> #{500 + floor_y + 2}, #{floor_y}"
rock_and_sand = rock_and_sand | rock_paths(floor_input)

count = 0
loop do
  count = count + 1
  landing_spot = pour(rock_and_sand, sand_source)
  break if landing_spot.nil?

  rock_and_sand.add(landing_spot)
  break if landing_spot == sand_source
end 
 p count

