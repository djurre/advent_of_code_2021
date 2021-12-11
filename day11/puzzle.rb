input = File.readlines('input.txt', chomp: true)
@grid = {}
input.each_with_index { |line, x| line.chars.map(&:to_i).each_with_index { |num, y| @grid[[x, y]] = num } }

def neighbour_coors(coor)
  ([-1, 0, 1].repeated_permutation(2).to_a - [0, 0]).map { |x, y| [coor[0] + x, coor[1] + y] }.compact.select { |coor| @grid.key?(coor) }
end

def power_up(coor)
  neighbour_coors(coor).each { |ncoor| power_up(ncoor) } if (@grid[coor] += 1) == 10
end

def step(steps)
  flash_count = 0
  (0..).each do |step|
    @grid.keys.each { |coor| power_up(coor) }
    new_flashes = @grid.values.count { |v| v > 9 }
    @grid.transform_values! { |v| v > 9 ? 0 : v }
    
    flash_count += new_flashes
    pp flash_count if step == steps
    return pp step + 1 if new_flashes == @grid.count
  end
end

step(100)
