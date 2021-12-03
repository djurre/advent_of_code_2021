input = File.readlines("input.txt").map { |s| s.chomp.split('').map(&:to_i) }

def array_to_i(array)
  array.join.to_i(2)
end

# Puzzle 1
rates = input.transpose.map(&:reverse).map { |row| [row.count(0), row.count(1)] }
gamma_rate = rates.map { |rate| rate.each_with_index.max[1] }
epsilon_rate = rates.map { |rate| rate.each_with_index.min[1] }
pp array_to_i(gamma_rate) * array_to_i(epsilon_rate)

# Puzzle 2
def reduce(filtered_input, method, index = 0)
  return filtered_input if filtered_input.length == 1
  counts = filtered_input.transpose.map(&:reverse).map { |row| [row.count(0), row.count(1)] }
  filter_rule = counts.map { |rate| rate.each_with_index.send(method)[1] }
  result = filtered_input.reject { |rate| rate[index] != filter_rule[index] }
  reduce(result, method, index + 1)
end

oxygen = reduce(input, :max)
co2 = reduce(input, :min)
pp array_to_i(oxygen) * array_to_i(co2)
