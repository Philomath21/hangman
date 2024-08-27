# Creating dictionary array as per given condition in project
def create_dictionary_a
  # Reading dictiory file as array of words
  dictionary_a = File.readlines 'google-10000-english-no-swears.txt'
  # Removing \n (whitespaces) from words
  dictionary_a.map!(&:strip)
  # Selecting words having 5 to 12 characters
  dictionary_a.select! { |word| (5..12).include? word.length }
end

class Game
  @@save_count = 0 # rubocop:disable Style/ClassVars
  attr_accessor :correct_letters_a, :incorrect_letters_a, :life_i, :secret_word_a

  def initialize
    # Selecting a secret word,i.e a random word from dictionary
    # And storing it in array format
    @secret_word_a = create_dictionary_a.sample.split('')

    # Wrong guesses remaining?
    @life_i = 7

    # Correct & incorrect guesses made by the player
    @correct_letters_a = []
    @incorrect_letters_a = []

    puts "----- HANGMAN -----
Welcome to the game!
You have to guess the secret word to win the game.
You must make less than #{life_i} incorrect guesses.\n "
  end

  # Save game on pressing 0
  def asked_to_save_game?(guess)
    return false unless guess == '0'

    @@save_count += 1 # rubocop:disable Style/ClassVars
    save_a = [secret_word_a.join, life_i, correct_letters_a.join, incorrect_letters_a.join]
    Dir.mkdir('save') unless Dir.exist?('save')
    filename = "save/game_#{@@save_count}"
    File.open(filename, 'w') { |file| file.puts save_a }
    puts 'Game saved successfully!'
    true
  end

  # Player makes a guess of letter
  def make_a_guess
    puts "Chances remaining: #{life_i}"
    puts 'Please guess a letter : '
    # making it case insensitive & validating it
    loop do
      guess = gets.chomp.downcase
      if (guess == '0') || (guess.length == 1 && guess.match?(/[A-Za-z]/))
        return guess unless (correct_letters_a + incorrect_letters_a).include? guess

        puts 'You have already entered this alphabet, please enter a new alphabet'
      else
        puts 'Please enter a valid alphabet'
      end
    end
  end

  # Check if guess is correct or incorrect
  def check_guess(guess)
    if secret_word_a.include?(guess)
      correct_letters_a.push(guess)
      puts "Your guess was correct!\n "
    else
      incorrect_letters_a.push(guess)
      self.life_i = life_i - 1
      puts "Your guess was incorect\n "
    end
  end

  # Check for a win
  def game_won?
    secret_word_a.each do |letter|
      return false unless correct_letters_a.include?(letter)
    end
    puts "The secret word was : #{secret_word_a.join(' ')}"
    puts 'CONGRATULATIONS! You have won the game!'
    true
  end

  # Check for game over (life_i == 0)
  def game_over?
    return false unless life_i.zero?

    puts "The secret word was : #{secret_word_a.join(' ')}"
    puts 'No chances remaining. GAME OVER!'
    true
  end

  # Print revealed letters in secret word & incorrect guesses
  def to_s
    word = ''
    secret_word_a.each do |letter|
      word += correct_letters_a.include?(letter) ? "#{letter} " : '_ '
    end

    "Secret word: #{word}
Incorrect letters are: #{incorrect_letters_a.join(', ')}"
  end
end
