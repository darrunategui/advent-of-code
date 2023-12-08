class AlmanacMap
  def initialize(legend)
    @maps = legend.each_slice(3).map { |dest, source, range|
      { dest:, source_min: source, source_max: source + range - 1 }
    }
  end

  def get(source_num)
    map = @maps.find { |m| m[:source_min] <= source_num && source_num <= m[:source_max] }
    return source_num if map.nil?

    map[:dest] + source_num - map[:source_min]
  end
end

class AlmanacReader
  def initialize(maps)
    @maps = maps
  end

  def location(seed)
    @maps.reduce(seed) { |acc, map| map.get(acc) }
  end
end

require '../input_reader'
seeds, *maps = InputReader.read.split(':').drop(1).map { |l| l.scan(/\d+/).map(&:to_i) }
maps = maps.map { |m| AlmanacMap.new(m) }.to_a

reader = AlmanacReader.new(maps)

# part 1
p seeds.map { |s| reader.location(s) }.min

# part 2
p seeds.each_slice(2)
  .map { |seed, range|
    seed.upto(seed+range-1).each_slice(100000).map { |slice| slice.map { |s| reader.location(s) }.min }.min
  }.min
