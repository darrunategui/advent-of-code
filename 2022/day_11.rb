require '../input_reader'
def input
  InputReader.read.split("\n\n").map { |monkey| 
    lines = monkey.split("\n")
    {
      monkey: lines[0].match(/\d+/).to_s.to_i,
      items: lines[1].scan(/\d+/).map { |d| d.to_i },
      operation: begin
        parsed = lines[2].split(' ')[-2..]
        operation = parsed[0]
        ->(worry, worry_divider, lcm) { 
          operand = parsed[1].match?(/\d+/) ? parsed[1].to_i : worry
          (worry.send(operation, operand)/worry_divider).floor % lcm
        }
      end,
      divisibility: lines[3].match(/\d+/).to_s.to_i,
      throw_to: begin
        divisible = lines[3].match(/\d+/).to_s.to_i
        outcome = {
          true => lines[4].match(/\d+/).to_s.to_i,
          false => lines[5].match(/\d+/).to_s.to_i,
        }
        ->(new_worry) { outcome[new_worry % divisible == 0] }
      end

    }
  }.to_h { |input| [input[:monkey], input] }
end

def watch_monkeys(input, rounds:, worry_divider:)
  results = input.keys.to_h { |monkey| [monkey, 0] }
  lcm = input.values.map { |n| n[:divisibility] }.reduce(:*)

  (1..rounds).each do |round|
    input.each do |monkey, notes|
      while (item = notes[:items].shift) != nil
        new_worry = notes[:operation].call(item, worry_divider, lcm)
        new_monkey = notes[:throw_to].call(new_worry)
        input[new_monkey][:items].push(new_worry)
        results[monkey] += 1
      end
    end
  end
  results.values.sort[-2..].reduce(:*)
end

# part 1
puts watch_monkeys(input, rounds: 20, worry_divider: 3)

# part 2
puts watch_monkeys(input, rounds: 10_000, worry_divider: 1)
