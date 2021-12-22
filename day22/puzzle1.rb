cubes = File.readlines('input.txt', chomp: true).filter_map do |line|
  on_off = line.start_with?('on') ? 1 : 0
  x1, x2, y1, y2, z1, z2 = line.scan(/-?\d+/).map(&:to_i)
  next if [x1, x2, y1, y2, z1, z2].map(&:abs).max > 50
  { state: on_off, x: (x1..x2), y: (y1..y2), z: (z1..z2) }
end

reactor = Hash.new(0)
cubes.each do |cube|
  (cube[:x]).each do |x|
    (cube[:y]).each do |y|
      (cube[:z]).each do |z|
        reactor[[x, y, z]] = cube[:state]
      end
    end
  end
end

pp reactor.values.sum