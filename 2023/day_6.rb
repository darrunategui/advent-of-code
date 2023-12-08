require 'cmath'

class QuadraticEquation
  attr_reader :a, :b, :c
  def initialize(a, b, c)
    @a = a
    @b = b
    @c = c
  end

  def solve
    d = b * b - 4 * a * c

    if d < 0
      Float::NAN
    elsif d == 0 
      (-b + CMath.sqrt(d)) / (2 * a)
    else
      x1 = (-b - CMath.sqrt(d)) / (2 * a)
      x2 = (-b + CMath.sqrt(d)) / (2 * a)
      [x1, x2]
    end 
  end
end

require '../input_reader'

# part 1
times, distances = InputReader.read.split("\n").map { |l| l.scan(/\d+/).map(&:to_i) }
races = times.zip(distances)
p races.map { |t, d|
  equation = QuadraticEquation.new(1, -t, d)
  solutions = equation.solve
  sol_1 = (solutions.first % 1 == 0) ? solutions.first.to_i + 1 : solutions.first.ceil
  sol_2 = (solutions.last % 1 == 0) ? solutions.last.to_i - 1 : solutions.last.floor
  sol_2 - sol_1 + 1
}.reduce(1, :*)

# part 2
time, distance = InputReader.read.split("\n").map { |l| l.scan(/\d+/).join.to_i }

equation = QuadraticEquation.new(1, -time, distance)
solutions = equation.solve
sol_1 = (solutions.first % 1 == 0) ? solutions.first.to_i + 1 : solutions.first.ceil
sol_2 = (solutions.last % 1 == 0) ? solutions.last.to_i - 1 : solutions.last.floor
p sol_2 - sol_1 + 1
