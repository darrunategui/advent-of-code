require '../input_reader'
input = InputReader.read

left = 0
right = 1
characters = { input[left] => left }
target_length = 14

while right < input.length do
  char = input[right]

  if characters[char].nil? && right - left < target_length
    characters[char] = right
    right += 1
    break if characters.keys.length == target_length
  else
    characters.delete(input[left])
    left += 1
  end
end

puts right
