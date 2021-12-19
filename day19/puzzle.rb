class Scanner
  attr_accessor :coor_array
  attr_accessor :id
  attr_accessor :relative_distances
  attr_accessor :normalized
  attr_accessor :offset

  def initialize(id, coor_array = [])
    self.id = id
    self.coor_array = coor_array
    self.relative_distances = {}

    coor_array.each_with_index do |(x1, y1, z1), index|
      relative_distances[index] = coor_array.map { |x2, y2, z2| ((x2 - x1).abs + (y2 - y1).abs + (z2 - z1).abs) }
    end
  end
end

def rotations(x, y, z, i)
  [[x, y, z], [x, -y, -z], [-x, y, -z], [-x, -y, z], [x, z, -y], [x, -z, y], [-x, z, y], [-x, -z, -y],
   [y, z, x], [y, -z, -x], [-y, z, -x], [-y, -z, x], [y, x, -z], [y, -x, z], [-y, x, z], [-y, -x, -z],
   [z, x, y], [z, -x, -y], [-z, x, -y], [-z, -x, y], [z, y, -x], [z, -y, x], [-z, y, x], [-z, -y, -x]][i]
end

def find_matching_beacons(scanner, scanners)
  scanners.each do |potential_scanner|
    next if scanner.id == potential_scanner.id
    next if !scanner.normalized && !potential_scanner.normalized

    scanner.relative_distances.each do |i, distances1|
      potential_scanner.relative_distances.each do |j, distances2|
        overlap = distances1 & distances2
        if overlap.count >= 12
          unnormalized_coors = overlap.map { |o| distances1.index(o) }.map { |index| scanner.coor_array[index] }
          normalized_coors = overlap.map { |o| distances2.index(o) }.map { |index| potential_scanner.coor_array[index] }
          next unless find_matching_transformation(normalized_coors, unnormalized_coors)
          return [normalized_coors, unnormalized_coors]
        end
      end
    end
  end
  false
end

def pair_wise_offsets(coors)
  coors.each_cons(2).map { |c1, c2| [c2[0] - c1[0], c2[1] - c1[1], c2[2] - c1[2]] }
end

def find_matching_transformation(coors1, coors2)
  c1_offsets = pair_wise_offsets(coors1.sort)
  24.times do |i|
    transformed_coors = coors2.map { |coor| rotations(*coor, i) }
    c2_offsets = pair_wise_offsets(transformed_coors.sort)
    return i if c1_offsets == c2_offsets
  end
  false
end

def find_offset(coors1, coors2)
  c1 = coors1.sort[0]
  c2 = coors2.sort[0]
  [c2[0] - c1[0], c2[1] - c1[1], c2[2] - c1[2]]
end

scanners = File.read('input.txt').split("\n\n").map { |block| block.split("\n")[1..].map { |l| l.split(',').map(&:to_i) } }.map.with_index { |coors, i| Scanner.new(i, coors) }
scanners[0].normalized = true
scanners[0].offset = [0, 0, 0]

while scanners.any? { |scanner| !scanner.normalized } do
  scanners.each do |source_scanner|
    next if source_scanner.normalized

    normalized_coors, unnormalized_coors = find_matching_beacons(source_scanner, scanners)
    next unless normalized_coors

    transformation_id = find_matching_transformation(normalized_coors, unnormalized_coors)
    transformed_matching = unnormalized_coors.map { |coor| rotations(*coor, transformation_id) }
    offset = find_offset(transformed_matching, normalized_coors)
    source_scanner.coor_array.map! { |coor| rotations(*coor, transformation_id) }
    source_scanner.coor_array.map! { |coor| [coor[0] + offset[0], coor[1] + offset[1], coor[2] + offset[2]] }
    source_scanner.normalized = true
    source_scanner.offset = offset
  end
end

# Part 1
all_coors = []
scanners.each { |scanner| all_coors += scanner.coor_array }
pp all_coors.uniq.count

# Part 2
manhattan = scanners.combination(2).map do |s1, s2|
  x1, y1, z1 = s1.offset
  x2, y2, z2 = s2.offset
  (x2 - x1).abs + (y2 - y1).abs + (z2 - z1).abs
end

pp manhattan.max
