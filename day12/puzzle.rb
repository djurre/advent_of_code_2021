input = File.readlines('input.txt', chomp: true).map { |l| l.split('-') }

@edges = Hash.new([])
input.each do |n1, n2|
  @edges[n1] += [n2] unless n2 == 'start'
  @edges[n2] += [n1] unless n1 == 'start' 
end

# Part 1
def walk1(node, path)
  return 1 if node == 'end'
  @edges[node].reject { |n| n.downcase == n && path.include?(n) }.sum { |next_node| walk1(next_node, path + [next_node]) }
end
pp walk1('start', ['start'])

# Part 2
def walk2(node, path)
  return 1 if node == 'end'
  @edges[node].reject do |n|
    n.downcase == n && path.include?(n) && path.tally.any? { |k, v| k.downcase == k && v == 2 }
  end.sum { |next_node| walk2(next_node, path + [next_node]) }
end
pp walk2('start', ['start'])

