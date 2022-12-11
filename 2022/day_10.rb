require '../input_reader'
require 'set'
input = InputReader.read.split("\n").map { |l| 
  { instruction: l.split(' ')[0], value: l.start_with?('add') ? l.split(' ').last.to_i : nil } 
}

reg_x = { 0 => 1 }
last = [0, 1]

input.each do |line|
  if line[:instruction] == 'noop'
    reg_x[last[0]+1] = last[1]
    last[0] = last[0]+1
  elsif line[:instruction] == 'addx'
    reg_x[last[0]+1] = last[1]
    reg_x[last[0]+2] = last[1] + line[:value]
    last[0] = last[0]+2
    last[1] = reg_x[last[0]]
  end
end

# part 1
cycles = (0...6).map { |i| 20 + 40*i }
puts cycles.map { |c| c * reg_x[c-1] }.sum

# part 2
puts reg_x.drop(1).map { |cycle, position|
  sprite_position = Set.new [-1, 0, 1].map{ |a| a + reg_x[cycle-1] }

 sprite_position.include?((cycle-1)%40) ? '#' : '.'
}.each_slice(40).map(&:join).join("\n")
