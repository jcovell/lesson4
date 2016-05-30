WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                [[1, 5, 9], [3, 5, 7]]              # diag

INITIAL_MARKER = ' '.freeze
PLAYER_MARKER = 'X'.freeze
COMPUTER_MARKER = 'O'.freeze
FIRST_PLAYER = 'choose'.freeze
WINNING_SCORE = 5

def prompt(msg)
  puts "=> #{msg}"
end

def clear_screen
  system('clear') || system('cls')
end

# rubocop:disable Metrics/MethodLength, Metrics/AbcSize
def display_board(brd)
  system 'clr'
  puts ' '
  puts "You're a #{PLAYER_MARKER}. Computer is #{COMPUTER_MARKER}."
  puts ""
  puts "     |     |"
  puts "  #{brd[1]}  |  #{brd[2]}  |  #{brd[3]}"
  puts "     |     |"
  puts "-----------------"
  puts "     |     |"
  puts "  #{brd[4]}  |  #{brd[5]}  |  #{brd[6]}"
  puts "     |     |"
  puts "-----------------"
  puts "     |     |"
  puts "  #{brd[7]}  |  #{brd[8]}  |  #{brd[9]}"
  puts "     |     |"
  puts ""
end
# rubocop:enable Metrics/MethodLength, Metrics/AbcSize

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

def choose_first_player
  answer = ''

  loop do
    prompt "Choose who gets to start: 1) You or 2) Computer"
    answer = gets.chomp
    break if %w(1 2).include?(answer)
    prompt "Sorry, that's not a valid choice. Please select the number 1 or 2."
  end

  if answer == '1'
    return 'player'
  elsif answer == '2'
    return 'computer'
  end
end

def player_marks!(brd)
  square = ''
  loop do
    prompt "Choose a square: #{joinor(empty_squares(brd), ', ')}"
    square = gets.chomp.to_i
    break if empty_squares(brd).include?(square)
    prompt "Sorry, that's not a valid choice."
  end
  brd[square] = PLAYER_MARKER
end

def computer_offense(brd, square='')
  WINNING_LINES.each do |line|
    square = find_at_risk_square(line, brd, COMPUTER_MARKER)
    break if square
  end
  square
end

def computer_defense(brd, square)
  WINNING_LINES.each do |line|
    square = find_at_risk_square(line, brd, PLAYER_MARKER)
    break if square
  end
  square
end

def computer_marks!(brd)
  square = computer_offense(brd)
  square = computer_defense(brd, square) unless square
  square = 5 if !square && empty_squares(brd).include?(5)
  square = empty_squares(brd).sample unless square
  brd[square] = COMPUTER_MARKER
end

def place_piece!(brd, current_player)
  current_player == 'computer' ? computer_marks!(brd) : player_marks!(brd)
end

def alternate_player(current_player)
  current_player == 'computer' ? 'player' : 'computer'
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def someone_won?(brd)
  !!detect_winner(brd)
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(PLAYER_MARKER) == 3
      return 'Player'
    elsif brd.values_at(*line).count(COMPUTER_MARKER) == 3
      return 'Computer'
    end
  end
  nil
end

def joinor(arr, delimiter=', ', word='or')
  arr[-1] = "#{word} #{arr.last}" if arr.size > 1
  arr.join(delimiter)
end

def find_at_risk_square(line, board, marker)
  if board.values_at(*line).count(marker) == 2
    board.select { |k, v| line.include?(k) && v == INITIAL_MARKER }.keys.first
  end
end

def prompt_separator(msg)
  puts "=> #{msg}\n----------------------------------------------------------"
end

clear_screen
puts ' '
puts "Welcome to Tic Tac Toe!"
puts ' '
puts "First one to get 5 points, wins the game."

loop do
  player_score = 0
  computer_score = 0
  continue_game = ''

  loop do
    board = initialize_board
    current_player = if FIRST_PLAYER == 'choose'
                       choose_first_player
                     else
                       FIRST_PLAYER
                     end

    loop do
      display_board(board)
      place_piece!(board, current_player)
      current_player = alternate_player(current_player)
      break if someone_won?(board) || board_full?(board)
    end

    display_board(board)

    if someone_won?(board)
      prompt "#{detect_winner(board)} ......WON !"
    else
      prompt "It's a tie!"
    end

    player_score += 1 if detect_winner(board) == "Player"
    computer_score += 1 if detect_winner(board) == "Computer"
    prompt("The score is Player: #{player_score}, Computer: #{computer_score}")
    break if player_score == WINNING_SCORE || computer_score == WINNING_SCORE

    loop do
      prompt "Start the next round? (Y to continue, N to quit.)"
      continue_game = gets.chomp
      break if continue_game.downcase.start_with?('y', 'n')
      prompt "Sorry, that's not a valid answer. Please enter Y or N."
    end
    break if continue_game.downcase.start_with?('n')
    clear_screen
  end

  if player_score == WINNING_SCORE
    prompt "That means >-->-->-->-->-->-->"
    prompt "You Won The Game!"
  elsif computer_score == WINNING_SCORE
    prompt ">-->-->-->-->-->-->"
    prompt "That means Computer won the game!"
  end

  break if continue_game.downcase.start_with?('n')

  answer = ''
  loop do
    prompt "Play another game? (Y to continue, N to quit)"
    answer = gets.chomp
    break if answer.downcase.start_with?('y', 'n')
    prompt "Sorry, that's not a valid answer. Please enter Y or N."
  end
  break if answer.downcase.start_with?('n')
end

prompt "Thanks for playing Tic Tac Toe! Good bye!"
