dots, folds = File.read('input.txt', chomp: true).split("\n\n")
dots = dots.split("\n").map { |d| d.split(',').map(&:to_i) }
folds = folds.split("\n").map { |fold| /^fold along (.)=(\d+)/.match(fold)&.captures }.map { [_1, _2.to_i] }
@grid = dots.each_with_object(Hash.new(false)) { |(x, y), h| h[[x, y]] = true }

def fold(axis, pos)
  @grid.keys.each do |x, y|
      @grid[[(pos * 2) - x, y]] |= @grid.delete([x, y]) if axis == 'x' && x > pos
      @grid[[x, (pos * 2) - y]] |= @grid.delete([x, y]) if axis == 'y' && y > pos
  end
end

def print_grid
  (0..@grid.keys.transpose[1].max).each { |y| (0..@grid.keys.transpose[0].max).each { |x| print @grid[[x, y]] == true ? "\u2588" : " " }; puts }
end

folds.each_with_index do |(axis, pos), index|
  fold(axis, pos)
  pp @grid.values.count(true) if index == 0
end
print_grid