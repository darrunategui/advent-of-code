require '../input_reader'


class Hand
  include Comparable

  attr_reader :cards
  def initialize(cards, wildcard = false)
    @cards = cards
    @wildcard = wildcard
    @card_values = {
      '2' => 0,
      '3' => 1,
      '4' => 2,
      '5' => 3,
      '6' => 4,
      '7' => 5,
      '8' => 6,
      '9' => 7,
      'T' => 8,
      'J' => wildcard ? -1 : 9,
      'Q' => 10,
      'K' => 11,
      'A' => 12,
    }
  end

  def rank
    grouped = @cards.chars.reduce({}) { |acc, c|
      acc[c] = acc.fetch(c, 0) + 1
      acc
    }.sort_by { |char, count| count }.reverse.to_h

    if @wildcard
      j = grouped.delete('J')
      if !j.nil?
        if grouped.empty?
          grouped['J'] = j
        else
          greatest_char = grouped.first.first
          grouped[greatest_char] = grouped[greatest_char] + j
        end
      end
    end

    result = grouped.values
  end

  def <=>(other)
    if rank.to_s < other.rank.to_s
      return -1
    elsif rank.to_s > other.rank.to_s
      return 1
    else
      pairs = cards.chars.zip(other.cards.chars)
      pairs.each { |t, o|
        if @card_values[t] < @card_values[o]
          return -1
        elsif @card_values[t] > @card_values[o]
          return 1
        end
      }
    end
  end
end


inputs = InputReader.read.split("\n")

# part 1 249390788
hands = inputs.map { |l|
  h = l.split(' ')
  [Hand.new(h[0]), h[1].to_i]
}
p hands.sort { |a, b| a[0] <=> b[0] }
  .map { |h| h.last }
  .to_enum.with_index(1)
  .map { |bet, index| bet * index }
  .sum

  # part 2 248750248
hands = inputs.map { |l|
  h = l.split(' ')
  [Hand.new(h[0], true), h[1].to_i]
}
p hands.sort { |a, b| a[0] <=> b[0] }
  .map { |h| h.last }
  .to_enum.with_index(1)
  .map { |bet, index| bet * index }
  .sum
