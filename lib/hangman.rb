require_relative "game"

# Gameplay logic
def play_game


  my_game = Game.new

  while true
    puts my_game
    guess = my_game.make_a_guess
    my_game.check_guess(guess)
    puts " "
  end
end

play_game
