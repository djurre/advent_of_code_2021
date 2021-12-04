input = File.read("input.txt", chomp: true).split("\n\n").map { |l| l.gsub("\n", " ") }
numbers = input.shift.split(',').map(&:to_i)
boards = input.map { |board_list| board_list.split.map(&:to_i).each_slice(5).to_a }.map { |board| board + board.transpose }

def play(numbers, boards)
  winning_boards = []
  numbers.each do |number|
    boards.each_with_index do |board, board_number|
      next if board.any? { |line| line.empty?}
      board.each do |row_or_column|
        row_or_column.delete(number)
        winning_boards << { board_number: board_number, number: number } if row_or_column.empty?
      end
    end
  end
  winning_boards
end

winning_boards = play(numbers, boards)
pp boards[winning_boards.first[:board_number]][0..4].flatten.sum * winning_boards.first[:number]
pp boards[winning_boards.last[:board_number]][0..4].flatten.sum * winning_boards.last[:number]