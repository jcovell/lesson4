require 'pry'

INITIAL_MARKER = ' '
PLAYER_MARKER = 'x'
COMPUTER_MARKER = 'O'

def prompt(msg)
  puts "=> #{msg}"
end

def display_board(brd)
  puts ""
  puts "     |     |"
  puts "  #{brd[1]}  |  #{brd[2]}  |  #{brd[3]}"  # Extract a value out of the hash.
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

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def empty_squares(brd) #Inspecting but not modifing the board.
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

def player_places_piece!(brd) # Modifies the board so id with !.
  square = ''
  loop do
    prompt "Choose a square (#{empty_squares(brd).join(', ')}):"  #Returns only empty squares.
    square = gets.chomp.to_i
    break if empty_squares(brd).include?(square)
    prompt "Sorry, that's not a valid choice."
  end

    brd[square] = PLAYER_MARKER
end

board = initialize_board
display_board(board)

player_places_piece!(board)
puts board.inspect
display_board(board)
