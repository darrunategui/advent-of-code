require_relative '../input_reader'
input = InputReader.read

# part 1
calibration_values = input.
  split("\n").
  map { |l|
    digits = l.scan(/\d{1}/)
    "#{digits.first}#{digits.last}".to_i
  }

puts calibration_values.reduce(0) { |acc, val|
  acc += val
}


# part 2
mappings = {
  "one" => "1",
  "two" => "2",
  "three" => "3",
  "four" => "4",
  "five" => "5",
  "six" => "6",
  "seven" => "7",
  "eight" => "8",
  "nine" => "9"
}

calibration_values = input.
  split("\n").
  map { |l|
    digits = l.scan(Regexp.new("(?=(\\d{1}|#{mappings.keys.join("|")}))")).to_a.flatten
    digits = digits.to_a.map { |d| mappings.fetch(d, d) }
    "#{digits.first}#{digits.last}".to_i
  }

puts calibration_values.reduce(0) { |acc, val| acc += val }
