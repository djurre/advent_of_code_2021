def new_grid
  grid = {}
  input = File.readlines('input.txt', chomp: true)
  input.each_with_index { |line, x| line.chars.map(&:to_i).each_with_index { |weight, y| grid[[x, y]] = { weight: weight, cost: Float::INFINITY, visited: false } } }
  grid
end

def neighbour_coors(grid, x, y)
  [[x + 1, y], [x - 1, y], [x, y + 1], [x, y - 1]].select { |c| grid.key?(c) }
end

def find_path(grid)
  tx = grid.keys.map { _1[0] }.max
  ty = grid.keys.map { _1[1] }.max
  grid[[0, 0]][:cost] = 0

  cqueue = Hash.new([])
  cqueue[0] = [[0, 0]]

  while cqueue.any? do
    lowest_cost, coors = cqueue.sort.first
    next_coor = coors.shift
    coors.any? ? cqueue[lowest_cost] = coors : cqueue.delete(lowest_cost)

    next_node = grid[next_coor]
    next_node[:visited] = true
    return grid[next_coor][:cost] if next_coor == [tx, ty]

    neighbour_coors(grid, next_coor[0], next_coor[1]).each do |neigh_coor|
      neigh_node = grid[neigh_coor]
      next if neigh_node[:visited] || neigh_node[:cost] != Float::INFINITY
      new_cost = neigh_node[:weight] + grid[next_coor][:cost]
      neigh_node[:cost] = new_cost if new_cost < neigh_node[:cost]
      cqueue[new_cost] = cqueue[new_cost].any? ? cqueue[new_cost] + [neigh_coor] : [neigh_coor]
    end
  end
end

# Part 1
pp find_path(new_grid)

# Part 2
big_grid = {}
grid = new_grid
dim = grid.keys.map(&:first).max + 1
(0..4).each do |x|
  (0..4).each do |y|
    grid.each do |(cx, cy), node|
      big_grid[[cx + x * dim, cy + y * dim]] = node.dup
      big_grid[[cx + x * dim, cy + y * dim]][:weight] = ((node[:weight] + x + y - 1) % 9) + 1
    end
  end
end

pp find_path(big_grid)
