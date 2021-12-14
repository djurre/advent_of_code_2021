template, rules_lines = File.readlines('input.txt', chomp: true).slice_before("").map { |v| v.reject(&:empty?) }
rules = rules_lines.map { |rule_line| rule_line.split(' -> ')}.to_h
template = template.first.chars

10.times do 
  inserts = template.each_cons(2).map.with_index { |pair, index|  [index + 1, rules[pair.join]] }
  inserts.reverse.each { |pos, char| template.insert(pos, char)}
end

min, max = template.tally.invert.keys.minmax
pp max - min
