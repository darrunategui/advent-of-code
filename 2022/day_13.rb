require '../input_reader'
input = InputReader.read.split("\n\n").map { |pair| 
  {
    left: eval(pair.split("\n")[0]),
    right: eval(pair.split("\n")[1]),
  }
}

def compare(left, right)
  #puts "comparing #{left} with  #{right}"
  if left.is_a?(Numeric) && right.is_a?(Numeric)
    return true if left < right
    return false if left > right
    return nil if left == right
  end

  left = [left] if left.is_a?(Numeric)
  right = [right] if right.is_a?(Numeric)

  for i in 0...[left.length, right.length].max
    return true if i == left.length
    return false if i == right.length 

    comparison = compare(left[i], right[i])
    #puts " = #{comparison}"
    return comparison if !comparison.nil?
  end
  nil
end

# part 1
in_order = input.each.with_index(1).filter_map { |pair, index|
  index if compare(pair[:left], pair[:right]) == true
}
puts in_order.sum
