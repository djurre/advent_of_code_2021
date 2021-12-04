input = File.read("input.txt", chomp: true).split("\n\n").map { |l| l.gsub("\n", " ") }

numbers = input.shift.split(',').map(&:to_i)

boards = {}

input.each_with_index do |board_list, index|
  board_numbers = board_list.split.map(&:to_i)
  board = board_numbers.each_slice(5).to_a
  boards[index] = board + board.transpose
end

def play(numbers, boards)
  numbers.each_with_index do |number, index|
    boards.each do |board_number, rows_or_columns|
      rows_or_columns.each do |row_or_column|
        row_or_column.delete(number)
        if row_or_column.empty?
          return number, rows_or_columns
        end
      end
    end
  end
end


# winning_number, remaining_board = play(numbers, boards)

# pp remaining_board[0..4].flatten.sum * winning_number

def play_til_last(numbers, boards)
  winning_boards = []
  numbers.each_with_index do |number, index|
    boards.each do |board_number, rows_or_columns|
      next if winning_boards.map{|b| b[:board_number]}.include?(board_number)
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

winning_boards = play_til_last(numbers, boards)
last_winner = winning_boards.last
pp last_winner[:rows_or_columns][0..4].flatten.sum * last_winner[:number]