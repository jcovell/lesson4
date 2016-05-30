# SET UP AND DISPLAY THE BOARD

# 1. Display the initial empty 3x3 board.
# 2. Ask the user to mark a square.
# 3. Computer marks a square.
# 4. Display the updated board state.
# 5. If winner, display winner.
# 6. If board is full, display tie.
# 7. If neither winner nor board is full, go to #2
# 8. Play again?
# 9. If yes, go to #1
# 10. Good bye!

# Create a data structure using a array, nested arry or a hash.  We are using a hash.  The keys will represent the square on the board and the values will represent what we display, either an X, O or space.  This hash or data structure will be what we use to represent the board state at any point and time in out application / program.  So save or initialize this as a variable called "board" and your initial values should always be space or ' '. This is a little repetative so create a method to initialize the board.
 # Don't have to pass in the board because I am going to return a new board.  And iterate through the range and then populate the new board with a space. then return the new board and then pass through the initialized_board method(board) to display board.  Now take advantage of the board that is passed in(brd).  This board that is passed in is a hash and the keys correlate with the spaces numbers (1..9). Now extract a value out of this hash with #{brd[1]} for each space and run to make sure it works.

def display_board(brd)
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

def initialize_board
  new_board = {}
  (1..9).each {|num| new_board[num] = ' '}
  new_board
end

board = initialize_board
display_board(board)

# This is one way to set up the initial board.
