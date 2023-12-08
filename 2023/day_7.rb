require '../input_reader'


class Hand
  include Comparable
  attr_reader :rank, :cards
  def initialize(cards)
    @cards = cards

    sorted_cards = cards.chars.sort.join

    @rank = if cards.match?(/(.)\1{4}/)
      7
    elsif sorted_cards.match?(/(.)\1{3}/)
      6
    elsif sorted_cards.match?(/((.)\2(.)\3{2}|(.)\4{2}(.)\5)/)
      5
    elsif sorted_cards.match?(/(.)\1{2}/)
      4
    elsif sorted_cards.chars.each_cons(2).count { |c| c.first == c.last } == 2
      3
    elsif sorted_cards.match?(/(.)\1/)
      2
    else
      1
    end
  end

  CARD_VALUES = {
    '2' => 0,
    '3' => 1,
    '4' => 2,
    '5' => 3,
    '6' => 4,
    '7' => 5,
    '8' => 6,
    '9' => 7,
    'T' => 8,
    'J' => 9,
    'Q' => 10,
    'K' => 11,
    'A' => 12,
  }

  def <=>(other)
    if rank < other.rank
      return -1
    elsif rank > other.rank
      return 1
    else
      pairs = cards.chars.zip(other.cards.chars)
      pairs.each { |t, o|
        if CARD_VALUES[t] < CARD_VALUES[o]
          return -1
        elsif CARD_VALUES[t] > CARD_VALUES[o]
          return 1
        end
      }
    end
  end
end

hands = InputReader.read.split("\n").map { |l|
  h = l.split(' ')
  [Hand.new(h[0]), h[1].to_i]
}

p hands.sort { |a, b| a[0] <=> b[0] }
  .map { |h| h.last }
  .to_enum.with_index(1)
  .map { |bet, index| bet * index }
  .sum

