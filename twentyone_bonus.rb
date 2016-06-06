SUITS = %w(Clubs Spades Hearts Diamonds).freeze
DECK_VALUES = %w(2 3 4 5 6 7 8 9 10 Jack Queen King Ace).freeze
DEALER_LIMIT = 17
WINNING_VALUE = 21
WINNING_SCORE = 5

def initialize_deck
  DECK_VALUES.product(SUITS).shuffle
end

def prompt(msg, space: false)
  puts "=> #{msg}"
  puts " " * 10 if space
end

def display_hands(hand_one, hand_two, player_turn = true)
  player_hand = ''
  dealer_hand = ''

  hand_one.each { |num| player_hand << "#{num.join(" of ")} ""and " }
  hand_two.each { |num| dealer_hand << "#{num.join(" of ")} " }

  prompt "Player: " + player_hand

  if player_turn
    prompt "Dealer: #{hand_two[0].join(" of ")} and another card face down.", space: true
  else
    prompt "Dealer: " + dealer_hand, space: true
  end
end

def calc_hand(hand)
  total = 0
  values = hand.map { |card| card[0] }

  values.each do |value|
    total += if value == 'Ace'
               11
             elsif value.to_i == 0
               10
             else
               value.to_i
             end
  end

  # correcting ace totals
  values.count { |value| value == 'Ace' }.times do
    total -= 10 if total > WINNING_VALUE
  end

  total
end

def calc_hidden_hand(hand)
  if hand[0][0] == 'Ace'
    11
  elsif hand[0][0].to_i == 0
    10
  else
    hand[0][0].to_i
  end
end

def display_totals(player:, dealer:)
  prompt "Points = Player: #{player} | Dealer: #{dealer}", space: true
end

def busted?(total)
  total > WINNING_VALUE
end

def detect_results(player:, dealer:)
  if player > WINNING_VALUE
    :player_busted
  elsif dealer > WINNING_VALUE
    :dealer_busted
  elsif player > dealer
    :player
  elsif player < dealer
    :dealer
  else
    :push
  end
end

def display_round_results(totals)
  result = detect_results(totals)

  case result
  when :player_busted
    prompt "You busted, dealer wins this hand!", space: true
  when :dealer_busted
    prompt "Dealer busted, you win this hand!", space: true
  when :player
    prompt "You win this hand!", space: true
  when :dealer
    prompt "Dealer wins this hand!", space: true
  when :push
    prompt "It's a push!", space: true
  end
end

def display_game_results(player:, dealer:)
  if player == WINNING_SCORE
    prompt "Way to go, you won the game!", space: true
    prompt "Final Score = Player: #{player} | Dealer: #{dealer}", space: true
  elsif dealer == WINNING_SCORE
    prompt "And Dealer wins the game!", space: true
    prompt "Final Score = Player: #{player} | Dealer: #{dealer}", space: true
  else
    prompt "Hands Won = Player: #{player} | Dealer: #{dealer}", space: true
    prompt "The first to win #{WINNING_SCORE} hands, is the winner.", space: true
  end
end

def clear_screen
  system('clear') || system('cls')
end

def display_welcome(started)
  clear_screen
  prompt "Welcome to the game of #{WINNING_VALUE}. Let's play!", space: true if started == false
end

loop do
  continue_game = ''
  answer = ''
  game_started = false
  scores = { player: 0, dealer: 0 }

  loop do   # Deal new hand.
    answer = ''

    deck = initialize_deck
    player_hand = []
    dealer_hand = []
    totals = { player: 0, dealer: 0 }

    2.times do
      player_hand << deck.pop
      dealer_hand << deck.pop
    end

    totals[:player] = calc_hand(player_hand)
    totals[:dealer] = calc_hidden_hand(dealer_hand)

    loop do  # Player's turn.
      answer = ''
      clear_screen
      display_welcome(game_started)
      game_started = true

      display_hands(player_hand, dealer_hand)
      display_totals(totals)

      loop do
        prompt "Would you like to (h)it or (s)tay?"
        answer = gets.chomp
        break if answer.downcase.start_with?('h', 's')
        prompt "Must enter a valid answer. Please enter h or s."
      end

      break if answer.downcase.start_with?('s')

      player_hand << deck.pop
      totals[:player] = calc_hand(player_hand)

      break if busted?(totals[:player])
    end

    totals[:dealer] = calc_hand(dealer_hand) # adding hidden card

    loop do   # Dealer's turn.
      break if totals[:dealer] >= DEALER_LIMIT || busted?(totals[:player])
      dealer_hand << deck.pop
      totals[:dealer] = calc_hand(dealer_hand)
    end

    clear_screen
    display_hands(player_hand, dealer_hand, false)
    display_totals(totals)
    display_round_results(totals)

    winner = detect_results(totals)
    if winner == :player || winner == :dealer_busted
      scores[:player] += 1
    elsif winner == :dealer || winner == :player_busted
      scores[:dealer] += 1
    end

    display_game_results(scores)
    break if scores.values.include?WINNING_SCORE

    loop do
      prompt "Play another hand? Enter (y)es or (n)o."
      continue_game = gets.chomp
      break if continue_game.downcase.start_with?('y', 'n')
      prompt "Must enter a valid answer. Please enter y or n."
    end
    break if continue_game.downcase.start_with?('n')
  end
  break if continue_game.downcase.start_with?('n')

  loop do
    prompt "Want to play another game to #{WINNING_VALUE}? Enter (y)es or (n)o."
    answer = gets.chomp
    break if answer.downcase.start_with?('y', 'n')
    prompt "Must enter a valid answer. Please enter y or n."
  end
  break if answer.downcase.start_with?('n')
end

clear_screen
prompt "Come back soon for another game of #{WINNING_VALUE}. Good bye!"
