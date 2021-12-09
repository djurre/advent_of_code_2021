input = File.readlines('input.txt', chomp: true)

@grid = {}

input.each_with_index do |line, x|
  line.chars.map(&:to_i).each_with_index do |num, y|
    @grid[[x, y]] = num
  end
end

def neighbours(x, y)
  [@grid[[x + 1, y]], @grid[[x - 1, y]], @grid[[x, y + 1]], @grid[[x, y - 1]]].compact
end

lowest_coors = @grid.map do |coor, value|
  coor if neighbours(coor[0], coor[1]).all? { |neigh| value < neigh }
end.compact

lowest = lowest_coors.map { |coor| @grid[coor] }
pp lowest.sum + lowest.length