require_relative '../input_reader'
input = InputReader.read


max_cubes = {
  "red" => 12,
  "green" => 13,
  "blue" => 14,
}

games = input.split("\n").map { |l|
  game_num, game_info = l.split(':')
  round_info = game_info.split(';').map { |i| 
    i.split(',').map { |r| r.strip }.to_h { |r|
      num, color = r.split(' ')
      [color, num.to_i]
    } 
  }
  
  game_num = game_num.match(/\d+/).to_s.to_i
  {
    game: game_num,
    rounds: round_info
  }
}

p games.filter { |g|
  g[:rounds].all? { |r| r.all? { |color, cubes| max_cubes[color] >= cubes } }
}.map { |g| g[:game] }.reduce(0) { |acc, num| acc += num }

p games.map { |g| g[:rounds] }.map { |rounds|
  rounds.reduce({ "red" => 0, "green" => 0, "blue" => 0 }) { |acc, round|
    round.each { |color, cubes|
      next if acc[color] >= cubes
      acc[color] = cubes
    }
    acc
  }
}.map { |mins| mins.values.reduce(1, :*) }.sum
