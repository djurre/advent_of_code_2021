input = File.readlines("input.txt", chomp: true)
ranges = input.map { |l| l.split(' -> ').map { |p| p.split(',').map(&:to_i) } }

def calculate(ranges, skip_diagonals)
  result = Hash.new(0)
  ranges.each do |(x1, y1), (x2, y2)|
    next if skip_diagonals && !(x1 == x2 || y1 == y2)

    x_dir, y_dir = x2 <=> x1, y2 <=> y1
    length = [(x1 - x2).abs, (y1 - y2).abs].max + 1
    length.times { |step| result[[x1 + step * x_dir, y1 + step * y_dir]] += 1 }
  end

  result.values.count { |v| v >= 2 }
end

pp calculate(ranges, true)
pp calculate(ranges, false)
