input = File.read("input.txt", chomp: true).split("\n\n").map { |l| l.gsub("\n", " ") }

numbers = input.shift.split(',').map(&:to_i)

boards = {}
input.each_with_index do |board_list, index|
  board = board_list.split.map(&:to_i).each_slice(5).to_a
  boards[index] = board + board.transpose
end

def play(numbers, boards)
  winning_boards = []
  numbers.each do |number|
    boards.each do |board_number, rows_or_columns|
      next if winning_boards.map { |b| b[:board_number] }.include?(board_number)
      rows_or_columns.each do |row_or_column|
        row_or_column.delete(number)
        if row_or_column.empty?
          winning_boards << { board_number: board_number, number: number, rows_or_columns: rows_or_columns }
        end
      end
    end
  end
  winning_boards
end

winning_boards = play(numbers, boards)
first_winner = winning_boards.first
last_winner = winning_boards.last
pp first_winner[:rows_or_columns][0..4].flatten.sum * first_winner[:number]
pp last_winner[:rows_or_columns][0..4].flatten.sum * last_winner[:number]