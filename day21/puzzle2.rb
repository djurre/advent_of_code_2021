@games = {}
@rolls = [1, 2, 3].repeated_permutation(3).map(&:sum)

def play(pos1, score1, pos2, score2)
  return [1, 0] if score1 >= 21
  return [0, 1] if score2 >= 21
  return @games[[pos1, score1, pos2, score2]] if @games.key?([pos1, score1, pos2, score2])

  win_count = [0, 0]
  @rolls.each do |roll|
    new_pos1 = ((pos1 + roll - 1) % 10) + 1
    new_score1 = score1 + new_pos1
    win1, win2 = play(pos2, score2, new_pos1, new_score1)
    win_count = [win_count[0] + win2, win_count[1] + win1]
  end

  @games[[pos1, score1, pos2, score2]] = win_count
  win_count
end

pp play(6, 0, 10, 0).max
