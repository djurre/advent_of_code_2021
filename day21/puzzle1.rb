@pos = [6, 10]
@points = [0, 0]
@dice = 1

def go(pnum)
  steps = (3 * @dice) + 3
  @pos[pnum] = ((@pos[pnum] + steps - 1) % 10) + 1
  @points[pnum] += @pos[pnum]
  @dice += 3
end

loop do
  go(0)
  break if @points[0] >= 1000
  go(1)
  break if @points[1] >= 1000
end

pp @points.min * (@dice - 1)
