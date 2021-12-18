require 'json'

class Pair

  attr_accessor :sub_pairs
  attr_accessor :value
  attr_accessor :index
  attr_accessor :depth
  attr_accessor :position

  def initialize(pair, depth)
    self.depth = depth
    if pair.is_a?(Array)
      self.sub_pairs = [Pair.new(pair[0], depth + 1), Pair.new(pair[1], depth + 1)]
    else
      self.sub_pairs = []
      self.value = pair
    end
  end

  def to_fish
    value ? value : [sub_pairs[0].to_fish, sub_pairs[1].to_fish]
  end

  def explode_actions
    return [] if value
    if depth == 4
      {
        left_add: [sub_pairs[0].index - 1, sub_pairs[0].value],
        right_add: [sub_pairs[1].index + 1, sub_pairs[1].value],
        collapse: [sub_pairs[0].index, sub_pairs[1].index]
      }
    else
      ex_left = sub_pairs[0].explode_actions
      ex_right = sub_pairs[1].explode_actions
      ex_left.any? ? ex_left : ex_right
    end
  end

  def re_index(highest = -1)
    if value
      self.index = highest + 1
    else
      self.index = nil
      h_left = self.sub_pairs[0].re_index(highest)
      self.sub_pairs[1].re_index(h_left)
    end
  end

  def explode(explode_actions)
    left_index, left_add = explode_actions[:left_add]
    right_index, right_add = explode_actions[:right_add]
    left_collapse_index, right_collapse_index = explode_actions[:collapse]

    self.value += left_add if self.index == left_index
    self.value += right_add if self.index == right_index

    if !value && [sub_pairs[0].index, sub_pairs[1].index] == [left_collapse_index, right_collapse_index]
      self.value = 0
      self.sub_pairs = []
    end

    sub_pairs.map { |p| p.explode(explode_actions) }
  end

  def split
    if value && value >= 10
      self.sub_pairs = [Pair.new(nil, depth + 1), Pair.new(nil, depth + 1)]
      sub_pairs[0].value = value / 2
      sub_pairs[1].value = (value + 1) / 2
      self.value = nil
      true
    elsif !value
      sub_pairs[0]&.split || sub_pairs[1]&.split
    end
  end

  def magnitude
    return value if value
    (sub_pairs[0].magnitude * 3) + (sub_pairs[1].magnitude * 2)
  end

end

def reduce(fish_array)
  p = Pair.new(fish_array, 0)
  loop do
    p.re_index
    actions = p.explode_actions
    split = false
    if actions.any?
      p.explode(actions)
    else
      split = p.split
    end

    return p.to_fish if actions.empty? && !split
  end
end

input = File.readlines('input.txt', chomp: true).map { |l| JSON.parse(l) }

# Part 1
result = input.inject do |n, line|
  reduce([n, line])
end
pp Pair.new(result, 0).magnitude

# Part 2
pp (input.permutation(2).map do |a, b|
  Pair.new(reduce([a, b]), 0).magnitude
end).max
