input = File.read('input.txt', chomp: true).split("\n\n")
@enhancement = input[0].chars.map { |c| c == '.' ? 0 : 1 }
image = Hash.new(0)
input[1].split("\n").each_with_index { |line, x| line.chars.each_with_index { |num, y| image[[x, y]] = num == '.' ? 0 : 1 } }

def neighbours_coors(coor)
  [-1, 0, 1].repeated_permutation(2).map { |neigh| coor.zip(neigh).map(&:sum) }
end

def calculate(image, loops)
  world_color = 0
  loops.times do
    updated_image = Hash.new(world_color)
    xmin, xmax = image.keys.transpose[0].minmax
    ymin, ymax = image.keys.transpose[1].minmax
    ((xmin - 2)..(xmax + 2)).each do |x|
      ((ymin - 2)..(ymax + 2)).each do |y|
        enhancement_index = neighbours_coors([x, y]).map { |neigh| image[neigh] }.join.to_i(2)
        updated_image[[x, y]] = @enhancement[enhancement_index]
      end
    end
    world_color = world_color == 0 ? @enhancement.first : @enhancement.last
    image = updated_image
    image.default = world_color
  end
  pp image.values.flatten.sum
end

calculate(image.dup, 2)
calculate(image.dup, 50)
