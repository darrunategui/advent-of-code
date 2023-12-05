require '../input_reader'
lines = InputReader.read.split("\n")

class ScratchCard
  attr_reader :number
  def initialize(line)
    @number = line.split(":").first.match(/\d+/).to_s.to_i
    @winning_nums = Set.new line.split(":").last.split("|").first.scan(/\d+/).map { |d| d.to_s.to_i }
    @guessed_nums = Set.new line.split(":").last.split("|").last.scan(/\d+/).map { |d| d.to_s.to_i }
  end

  def winner?
    winners.any?
  end

  def winners
    @winners ||= @winning_nums & @guessed_nums
  end

  def won_scratch_card_nums
    @won_scratch_card_nums ||= (0...winners.length).map { |n| @number + n + 1 }
  end

  def points
    @points ||= (0...winners.length).reduce(0) { |acc, i| i == 0 ? 1 : acc*2 }
  end
end

class ScratchCardChecker
  def initialize(scratch_cards)
    @cards_hash = scratch_cards.to_h { |s| [s.number, s] }
  end

  def points
    @cards_hash.values.sum { |s| s.points }
  end

  def number_of_scratchcards
    to_check = @cards_hash.values
    count = 0

    while to_check.any?
      next_up = to_check.pop
      count += 1
      to_check.push *next_up.won_scratch_card_nums.map { |n| @cards_hash[n] }
    end

    count
  end
end

scratch_cards = lines.map { |l| ScratchCard.new(l) }
checker = ScratchCardChecker.new(scratch_cards)

# part 1 22488
p checker.points

# part 2 7013204
p checker.number_of_scratchcards
