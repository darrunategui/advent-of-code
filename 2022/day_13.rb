require '../input_reader'

def compare(left, right)
  return 0 if left == right
  return left <=> right if left.is_a?(Numeric) && right.is_a?(Numeric)
  return compare([left], right) if left.is_a?(Numeric)
  return compare(left, [right]) if right.is_a?(Numeric)
  return -1 if left.length == 0
  return 1 if right.length == 0

  comparison = compare(left[0], right[0])
  return comparison == 0 ? compare(left[1..], right[1..]) : comparison
end

# part 1
input = InputReader.read.split("\n\n").map { |pair| 
  {
    left: eval(pair.split("\n")[0]),
    right: eval(pair.split("\n")[1]),
  }
}
puts input.each.with_index(1).filter_map { |pair, index|
  index if compare(pair[:left], pair[:right]) == -1
}.sum

# part 2
input = InputReader.read.split("\n").
  filter { |l| !l.strip.empty? }.
  push("[[2]]", "[[6]]").
  map { |l| eval(l) }

puts input.sort { |l, r| compare(l, r) }.filter_map.with_index(1) { |v, i|
  i if v == [[2]] || v == [[6]]
}.reduce(:*)
