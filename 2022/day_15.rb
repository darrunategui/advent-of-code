require '../input_reader'
require '../coordinate'
require 'set'

class Map
  attr_reader :sensor_distances, :sensor_beacons, :beacons, :sensors
  def initialize(input)
    @sensor_beacons = input
    @beacons = Set.new(input.values)
    @sensors = Set.new(input.keys)
    @sensor_distances = calculate_distances(input)
  end

  def calculate_distances(sensor_beacons)
    sensor_beacons.to_h { |s, b|
      [s, Coordinate.distance_between(s, b)]
    }
  end
end

sensor_beacons = InputReader.read.split("\n").to_h { |l|
  digits = l.scan(/\-?\d+/)
  [
    Coordinate.new(digits[0].to_i, digits[1].to_i),
    Coordinate.new(digits[2].to_i, digits[3].to_i),
  ]
}.freeze
map = Map.new(sensor_beacons)

# part 1
min_x = map.sensor_distances.min_by { |s, d| s.x - d }
max_x = map.sensor_distances.max_by { |s, d| s.x + d }
min_x = min_x[0].x - min_x[1]
max_x = max_x[0].x + max_x[1]

row_to_check = 2000000
empty_coords = (min_x..max_x).filter_map { |x|
  coord = Coordinate.new(x, row_to_check)
  map.sensor_distances.any? { |s, d|
    Coordinate.distance_between(coord, s) <= d &&
    !map.sensors.include?(coord) &&
    !map.beacons.include?(coord)
  } ? coord : nil
}
p empty_coords.length

# part 2
distress = nil
bound = [Coordinate.new(0,0), Coordinate.new(4_000_000, 4_000_000)]
map.sensor_distances.each do |s, d|
  edge_distance = d + 1
  shifts = [
    [->(c) { Coordinate.new(c.x, c.y - edge_distance) }, 'U', 'R'],
    [->(c) { Coordinate.new(c.x + edge_distance, c.y) }, 'U', 'L'],
    [->(c) { Coordinate.new(c.x, c.y + edge_distance) }, 'D', 'L'],
    [->(c) { Coordinate.new(c.x - edge_distance, c.y) }, 'D', 'R'],
  ]
  break if shifts.any? { |start_proc, shift_1, shift_2|
    coord = start_proc.call(s)
    (edge_distance).times.any? do
      next if coord.x < bound[0].x || coord.x > bound[1].x || coord.y < bound[0].y || coord.y > bound[1].y

      found = !map.sensor_distances.filter { |z| z != s }.any? { |zs, zd|
        Coordinate.distance_between(coord, zs) <= zd
      }
      if found
        distress = coord
        true
      else
        coord = coord.move(shift_1).move(shift_2)
        false
      end
    end
  }
end
p distress.x * 4_000_000 + distress.y
