input = File.readlines("input.txt").map(&:split).map { |a,b| [a, b.to_i]}

# part 1
directions = input.each_with_object(Hash.new(0)) { |v, h| h[v[0]] += v[1] }
pp directions["forward"] * (directions["down"] - directions["up"])

# part 2
pos, depth, aim = 0, 0, 0
input.each do |command, value|
  case command
  when 'forward'
    pos += value
    depth += aim * value
  when 'down'
    aim += value
  when 'up'
    aim -= value
  end
end

pp pos * depth