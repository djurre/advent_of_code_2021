template, rules_lines = File.read('input.txt', chomp: true).split("\n\n")
rules = rules_lines.split("\n").map { |rule_line| rule_line.split(' -> ') }.map { [_1.chars, _2] }.to_h

char_counts = Hash.new(0).merge(template.chars.tally)
pair_counts = template.chars.each_cons(2).each_with_object(Hash.new(0)) { |pair, h| h[pair] += 1 }

40.times do
  pair_counts.dup.each do |pair, count|
    char = rules[pair]
    pair_counts[[pair[0], char]] += count
    pair_counts[[char, pair[1]]] += count
    pair_counts[pair] -= count
    char_counts[char] += count
  end
end

min, max = char_counts.invert.keys.minmax
pp max - min
