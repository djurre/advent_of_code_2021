input = File.readlines("input.txt").map(&:to_i)

pp input.each_cons(2).count { |p| p[1] > p[0] }

# part ii - simple approach
pp input.each_cons(3).map(&:sum).each_cons(2).count { |p| p[1] > p[0] }

# part ii - smarter approach
# (a + b + c) < (b + c + d) => a < d
pp input.each_cons(4).count { |p| p.last > p.first }