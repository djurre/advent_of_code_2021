input = File.readlines('input.txt', chomp: true)
@grid = {}
input.each_with_index do |line, x|
  line.chars.map(&:to_i).each_with_index { |num, y| @grid[[x, y]] = num }
end

# Part 1
def neighbours(x, y)
  [@grid[[x + 1, y]], @grid[[x - 1, y]], @grid[[x, y + 1]], @grid[[x, y - 1]]].compact
end

lowest_coors = @grid.map { |coor, value| coor if neighbours(coor[0], coor[1]).all? { |neigh| value < neigh } }.compact
lowest = lowest_coors.map { |coor| @grid[coor] }
pp lowest.sum + lowest.length

# Part 2
def neighbours_coors(x, y)
  [[x + 1, y], [x - 1, y], [x, y + 1], [x, y - 1]].reject { |coor| [nil, 9].include?(@grid[coor]) }
end

def basin_neighbours(visited, coor)
  return if visited.include?(coor)
  visited << coor
  neighbours_coors(coor[0], coor[1]).each { |neigh_coor| basin_neighbours(visited, neigh_coor) }
  visited
end

result = lowest_coors.map { |low_coor| basin_neighbours([], low_coor) }.map(&:count).sort.reverse[0..2].inject(:*)
pp result