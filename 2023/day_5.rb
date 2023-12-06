class AlmanacMap
  attr_reader :value
  def initialize(legend)
    @maps = legend.each_slice(3).map { |dest, source, range|
      min = source
      max = source + range - 1
      
    }

    @value = legend.each_slice(3).reduce({}) { |acc, v|
      (0...v[2]).map { |i| acc[v[1]+i] = v[0]+i }
      acc
    }
  end

  def get(source_num)
    @value.fetch(source_num, source_num)
  end
end

class AlmanacReader
  def initialize(maps)
    @maps = maps
  end

  def location(seed)
    @maps.reduce(seed) { |acc, map|
      map.get(acc)
    }
  end
end

require '../input_reader'
seeds, *maps = InputReader.read.split(":").drop(1)
  .map { |l| l.scan(/\d+/).map { |d| d.to_i } }
#seed_to_soil,
#soil_to_fertilizer,
#fertilizer_to_water,
#water_to_light,
#light_to_temperature,
#temperature_to_humidity,
#humidity_to_location = maps.map { |m| AlmanacMap.new(m) }

reader = AlmanacReader.new(maps.map { |m| AlmanacMap.new(m) }.to_a)

p seeds.map { |s| reader.location(s) }.min


