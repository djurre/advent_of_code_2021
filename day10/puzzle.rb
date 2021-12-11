input = File.readlines('input.txt', chomp: true)

# Produces array of [position_corrupted_char, reduced_line]
reduced_lines = input.each { |line| line.length.times { line.gsub!(/\(\)|\[\]|<>|{}/, '') } }
incomplete, corrupted = reduced_lines.map { |l| l =~ /]|\)|>|}/i }.zip(reduced_lines).partition { _1[0].nil? }

# Part 1
illegal_points = { ')' => 3, ']' => 57, '}' => 1197, '>' => 25137 }
pp corrupted.sum { |pos, pline| illegal_points[pline.chars[pos]] }

# Part 2
completion_points = { '(' => 1, '[' => 2, '{' => 3, '<' => 4 }
completion_scores = incomplete.flatten.compact.map { |pline| pline.reverse.chars.inject(0) { |score, char| score * 5 + completion_points[char] } }
pp completion_scores.sort[completion_scores.length / 2]
