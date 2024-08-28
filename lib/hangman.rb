require_relative 'game'

# Print welcome message
def print_welcome
  puts "----- HANGMAN -----
Welcome to the game!
You have to guess the secret word to win the game.
You must make less than 7 incorrect guesses.

Press '1' > New Game
Press '2' > Load Game"
end

# Lets player select new game or load game
# returnes class Game object
def select_new_or_load
  loop do
    case gets.chomp
    when '1' then return Game.new
    when '2' then return Game.load_game
    else          puts 'Invalid input. Please enter a valid input : '
    end
  end
end

# Gameplay logic code stepwise
def play_game(mygame)
  until mygame.game_won? || mygame.game_over?
    puts mygame
    guess = mygame.make_a_guess
    break if mygame.asked_to_save_game?(guess)

    mygame.check_guess(guess)
  end
end

# Function call to play the game
print_welcome
play_game(select_new_or_load)
