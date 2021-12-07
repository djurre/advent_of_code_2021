positions = File.read('input.txt').split(',').map(&:to_i)
range = (positions.min..positions.max)

# Part 1
p range.map { |location| positions.sum { |position| (position - location).abs } }.min

# Part 2
p range.map { |location| positions.sum { |position| distance = (position - location).abs; distance * (distance + 1) / 2 } }.min