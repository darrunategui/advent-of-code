require '../input_reader'
input = InputReader.read

grid = input.split("\n").map { |row| row.chars.map { |c| c.to_i } }

# part 1
from_left = [0...grid.length, 0...grid.length, ->(x, y) { [x, y] }]
from_top = [(grid.length-1).downto(0), 0...grid.length, ->(x, y) { [y, x] }]
from_right = [(grid.length-1).downto(0), (grid.length-1).downto(0), ->(x, y) { [x, y] }]
from_bottom = [0...grid.length, (grid.length-1).downto(0), ->(x, y) { [y, x] }]

def visible_coordinates(grid, inputs)
  max = -1
  coordinates = []
  for x in inputs[0] do
    for y in inputs[1] do
      indexer = inputs[2].call(x, y)
      height = grid[indexer[0]][indexer[1]]
      if height > max
        coordinates << [indexer[0], indexer[1]]
        max = height
      end
      break if max == 9
    end
    max = -1
  end
  coordinates
end

visible = [
  *visible_coordinates(grid, from_left), *visible_coordinates(grid, from_top), 
  *visible_coordinates(grid, from_right), *visible_coordinates(grid, from_bottom),
]
puts visible.uniq.length


# part 2
to_left = [->(coord) { [coord[0]] }, ->(coord) { coord[1].downto(0) }, ->(x, y) { [x, y] }]
to_top = [->(coord) { [coord[1]] }, ->(coord) { coord[0].downto(0) }, ->(x, y) { [y, x] }]
to_right = [->(coord) { [coord[0]] }, ->(coord) { coord[1]...grid.length }, ->(x, y) { [x, y] }]
to_bottom = [->(coord) { [coord[1]] }, ->(coord) { coord[0]...grid.length }, ->(x, y) { [y, x] }]
  
def scenic_score(grid, coordinate, direction)
  score = -1
  reference_height = grid[coordinate[0]][coordinate[1]]
  for x in direction[0].call(coordinate)
    for y in direction[1].call(coordinate)
      indexer = direction[2].call(x, y)
      height = grid[indexer[0]][indexer[1]]
      score += 1
      break if height >= reference_height && indexer != coordinate
    end
  end
  score
end

puts visible.uniq.map { |coord|
  scenic_score(grid, coord, to_left) * scenic_score(grid, coord, to_top) *
  scenic_score(grid, coord, to_right) * scenic_score(grid, coord, to_bottom)
}.max
