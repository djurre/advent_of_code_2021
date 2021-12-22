class Range
  def overlaps?(other)
    cover?(other.first) || other.cover?(first)
  end
end

def split(cube, existing_cube)
  c1 = { state: 1, x: (existing_cube[:x].first..(cube[:x].first - 1)), y: existing_cube[:y], z: existing_cube[:z] }
  c2 = { state: 1, x: ((cube[:x].last + 1)..existing_cube[:x].last), y: existing_cube[:y], z: existing_cube[:z] }

  x_bound_left = [existing_cube[:x].first, cube[:x].first].max
  x_bound_right = [existing_cube[:x].last, cube[:x].last].min
  c3 = { state: 1, x: (x_bound_left..x_bound_right), y: (existing_cube[:y].first..(cube[:y].first - 1)), z: existing_cube[:z] }
  c4 = { state: 1, x: (x_bound_left..x_bound_right), y: ((cube[:y].last + 1)..existing_cube[:y].last), z: existing_cube[:z] }

  y_bound_left = [existing_cube[:y].first, cube[:y].first].max
  y_bound_right = [existing_cube[:y].last, cube[:y].last].min
  c5 = { state: 1, x: (x_bound_left..x_bound_right), y: (y_bound_left..y_bound_right), z: (existing_cube[:z].first..(cube[:z].first - 1)) }
  c6 = { state: 1, x: (x_bound_left..x_bound_right), y: (y_bound_left..y_bound_right), z: ((cube[:z].last + 1)..existing_cube[:z].last) }

  @on_cubes += [c1, c2, c3, c4, c5, c6].select { |c| c[:x].count > 0 && c[:y].count > 0 && c[:z].count > 0 }
end

def split_overlaps(cube, cubes_to_check)
  cubes_to_check.each do |existing_cube|
    next if cube[:x] == existing_cube[:x] && cube[:y] == existing_cube[:y] && cube[:z] == existing_cube[:z]

    if cube[:x].overlaps?(existing_cube[:x]) && cube[:y].overlaps?(existing_cube[:y]) && cube[:z].overlaps?(existing_cube[:z])
      existing_cube[:split] = true
      split(cube, existing_cube)
    end
  end
end

@cubes = File.readlines('input.txt', chomp: true).filter_map do |line|
  on_off = line.start_with?('on') ? 1 : 0
  x1, x2, y1, y2, z1, z2 = line.scan(/-?\d+/).map(&:to_i)
  { state: on_off, x: (x1..x2), y: (y1..y2), z: (z1..z2) }
end

@on_cubes = []
@cubes.each do |cube|
  @on_cubes << cube if cube[:state] == 1
  split_overlaps(cube, @on_cubes)
  @on_cubes.reject! { |c| c[:split] == true }
end

pp @on_cubes.sum { |c| c[:x].count * c[:y].count * c[:z].count }
