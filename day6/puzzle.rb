counts = File.read('input.txt').split(',').map(&:to_i).tally

def calculate(days, fish)
  days.times do
    num_new = fish[0]
    fish.transform_keys! { |k| (k - 1) % 9 }
    fish[6] += num_new
  end
  fish.values.sum
end

pp calculate(80, Hash.new(0).merge(counts))
pp calculate(256, Hash.new(0).merge(counts))
