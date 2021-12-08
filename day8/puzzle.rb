input = File.readlines('input.txt', chomp: true).map { |line| line.split('|').map { |part| part.split.map { |encoding| encoding.chars.sort.join } } }

# Part 1
pp input.transpose[1].flatten.count { |observation| [2, 3, 4, 7].include?(observation.length) }

# Part 2
def find_number(patterns, length, subtract, count)
  patterns.detect { |l| l.length == length && (l.chars - subtract.chars).length == count }
end

result = input.map do |pattern, observation|
  res = {}
  res[1] = find_number(pattern, 2, '', 2)
  res[7] = find_number(pattern, 3, '', 3)
  res[4] = find_number(pattern, 4, '', 4)
  res[8] = find_number(pattern, 7, '', 7)
  res[3] = find_number(pattern, 5, res[1], 3)
  res[6] = find_number(pattern, 6, res[1], 5)
  res[2] = find_number(pattern, 5, res[4], 3)
  res[9] = find_number(pattern, 6, res[3], 1)
  res[5] = find_number(pattern, 5, res[6], 0)
  res[0] = find_number(pattern, 6, res[5], 2)
  observation.map { |obs| res.key(obs) }.join.to_i
end.sum

pp result