require '../input_reader'
input = InputReader.read.
  split("\n").
  map { |l| 
    l.split(' ').filter { |f| f =~ /\A\d+\Z/ }.map(&:to_i)
  }

queues = [
    ['H', 'R', 'B', 'D', 'Z', 'F', 'L', 'S'],
    ['T', 'B', 'M', 'Z', 'R'],
    ['Z', 'L', 'C', 'H', 'N', 'S'],
    ['S', 'C', 'F', 'J'],
    ['B','Z','R','W','H','G','P'].reverse,
    ['T','M','N','D','G','Z','J','V'].reverse,
    ['Q','P','S','F','W','N','L','G'].reverse,
    ['R','Z','M'].reverse,
    ['T','R','V','G','L','C','M'].reverse
]

input.each do |i|
    removed = queues[i[1]-1].pop(i[0])
    queues[i[2]-1].push(*removed)
end

result = queues.map { |q| q.last }.join
puts result