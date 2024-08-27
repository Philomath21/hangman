require_relative 'game'

# Gameplay logic
def play_game
  my_game = Game.new
  until my_game.game_won? || my_game.game_over?
    puts my_game
    guess = my_game.make_a_guess
    break if my_game.asked_to_save_game?(guess)

    my_game.check_guess(guess)
  end
end

play_game
