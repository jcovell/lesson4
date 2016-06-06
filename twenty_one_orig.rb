# 1. Initialize deck
# 2. Deal cards to player and dealer
# 3. Player turn: hit or stay
#   - repeat until bust or "stay"
# 4. If player bust, dealer wins.
# 5. Dealer turn: hit or stay
#   - repeat until total >= 17
# 6. If dealer bust, player wins.
# 7. Compare cards and declare winner.

SUIT = %w(H D C S).freeze
CARDS = %w(A 2 3 4 5 6 7 8 9 10 J Q K).freeze
# DEALER_LIMIT = 17
# WIN_VALUE = 21
# WINNING_SCORE = 5

def initialize_deck
  deck = []
  SUIT.each do |suit|
    CARDS.each do |card|
      deck << [suit, card]
    end
  end
  deck.shuffle!
end

def deal_card!(deck)
  deck.shift
end

def deal_initial_hand(deck, player_hand, computer_hand)
  2.times do
    player_hand << deal_card!(deck)
    computer_hand << deal_card!(deck)
  end
end

def card_suit(card)
  case card
  when 'H'
    'Hearts'
  when 'D'
    'Diamonds'
  when 'C'
    'Clubs'
  when 'S'
    'Spades'
  end
end

def suit_card(card)
  case card
  when 'J'
    'Jack'
  when 'Q'
    'Queen'
  when 'K'
    'King'
  when 'A'
    'Ace'
  else
    card
  end
end

def cards_in_hand(hand, conceal_hand)
  cards = []
  hand.each do |card|
    cards << "#{suit_card(card[1])} of #{card_suit(card[0])}"
    if conceal_hand
      cards << "one hidden card"
      return cards
    end
  end
  cards
end

def construct_hand(index, cards)
  if index < (cards.count - 2)
    cards[index] + ', '
  elsif index < (cards.count - 1)
    cards[index]
  else
    ' and ' + cards[index]
  end
end

def display_hand(hand, player, conceal_hand = false)
  string = ''
  cards = cards_in_hand(hand, conceal_hand)
  cards.each_index do |index|
    string += construct_hand(index, cards)
  end
  if conceal_hand == false
    "The #{player} has a total of #{calculate_hand(hand)}; #{string}"
  else
    "The #{player} has: #{string}"
  end
end

def calculate_hand(hand)
  total = 0

  hand.each do |card|
    if card[1].to_i == 0
      total += 10
    elsif card[1] == 'A'
      total += 11
    else
      total += card[1].to_i
    end
  end

  hand.count { |card| card[1] == 'A' }.times do
    total -= 10 if total > 21
  end

  total
end

def busted?(hand)
  calculate_hand(hand) > 21
end

def twenty_one?(hand)
  calculate_hand(hand) == 21
end

def display_game_state(player_hand, dealer_hand, conceal_hand = true)
  system 'clear'
  puts display_hand(dealer_hand, 'dealer', conceal_hand)
  puts display_hand(player_hand, 'player')
end

def hit_or_stay(deck, player_hand, dealer_hand)
  loop do
    display_game_state(player_hand, dealer_hand)
    puts 'Would you like to hit or stay? [h] or [s]'
    break if gets.chomp.downcase.start_with?('s')
    player_hand << deal_card!(deck)
    break if busted?(player_hand) || twenty_one?(player_hand)
  end
end

def dealers_round(deck, player_hand, dealer_hand)
  loop do
    display_game_state(player_hand, dealer_hand, false)
    break if busted?(dealer_hand) || twenty_one?(dealer_hand)
    calculate_hand(dealer_hand) < 17 ? dealer_hand << deal_card!(deck) : break
    sleep(1)
  end
end

def play_again?
  puts ''
  puts 'Would you like to play again? [y] or [n]'
  gets.chomp.downcase.start_with?('y')
end

loop do
  deck = initialize_deck
  player_hand = []
  dealer_hand = []

  deal_initial_hand(deck, player_hand, dealer_hand)

  hit_or_stay(deck, player_hand, dealer_hand)

  display_game_state(player_hand, dealer_hand, false)

  if twenty_one?(player_hand)
    puts 'Player hit 21! Player won!'
  elsif busted?(player_hand)
    puts 'Player bust! Dealer wins!'
  else
    dealers_round(deck, player_hand, dealer_hand)
    if twenty_one?(dealer_hand)
      puts 'Dealer hit 21! Dealer won!'
    elsif busted?(dealer_hand)
      puts 'Dealer bust! Player wins!'
    else
      if calculate_hand(player_hand) > calculate_hand(dealer_hand)
        puts 'Player wins!'
      else
        puts 'Dealer wins!'
      end
    end
  end

  break unless play_again?
end

puts 'Thanks for playing!'
