require '../input_reader'
lines = InputReader.read.split("\n")

class ScratchCard
  attr_reader :number, :winning_nums, :guessed_nums
  def initialize(line)
    @number = line.split(":").first.match(/\d+/).to_s.to_i
    @winning_nums = Set.new line.split(":").last.split("|").first.scan(/\d+/).map { |d| d.to_s.to_i }
    @guessed_nums = Set.new line.split(":").last.split("|").last.scan(/\d+/).map { |d| d.to_s.to_i }
  end

  def winner?
    winners.any?
  end

  def winners
    @winning_nums & @guessed_nums
  end

  def won_scratch_card_nums
    return [] if !winner? 
    (0...winners.length).map { |n| @number + n + 1 }
  end

  def points
    return 0 if !winner?
    return 1 if winners.length == 1
    (1...winners.length).reduce(1) { |acc, _| acc *= 2 }
  end

end

scratch_cards = lines.map { |l| ScratchCard.new(l) }.to_h { |s| [s.number, s] }

# part 1
p scratch_cards.values.sum { |s| s.points }


def recurse(scratch_card, all_cards)
  traversed = [scratch_card]

  scratch_card.won_scratch_card_nums.each { |n|
    traversed.push *recurse(all_cards[n], all_cards)
  }

  traversed
end

# part 2
p scratch_cards.values
  .map { |s| recurse(s, scratch_cards) }
  .flatten
  .map { |s| s.number }
  .length
