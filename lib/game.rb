class Game
  attr_accessor :secret_word_a, :correct_letters_a, :incorrect_letters_a, :life_i

  def create_dictionary_a
    # Reading dictiory file as array of words
    dictionary_a = File.readlines 'google-10000-english-no-swears.txt'
    # Removing \n (whitespaces) from words
    dictionary_a.map!(&:strip)
    # Selecting words having 5 to 12 characters
    dictionary_a.select! { |word| (5..12).include? word.length }
  end

  def initialize
    @dictionary_a = create_dictionary_a

    # Selecting a secret word,i.e a random word from dictionary
    # And storing it in array format
    @secret_word_a = @dictionary_a.sample.split('')

    # Wrong guesses remaining?
    @life_i = 5

    # Correct & incorrect guesses made by the player
    @correct_letters_a = []
    @incorrect_letters_a = []
  end

  # Player makes a guess of letter
  def make_a_guess
    puts 'Guess a letter'
    while true
      # making it case insensitive & validating it
      guess = gets.chomp.downcase
      if guess.length == 1 && guess.match?(/[A-Za-z]/)
        break unless (correct_letters_a + incorrect_letters_a).include? guess

        puts 'You have already entered this alphabet, please enter a new alphabet'
      else
        puts 'Please enter a valid alphabet'
      end
    end
    guess
  end

  # Check if guess is correct or incorrect
  def check_guess(guess)
    if secret_word_a.include?(guess)
      correct_letters_a.push(guess)
      puts 'Your guess was correct!'
    else
      incorrect_letters_a.push(guess)
      puts 'Your guess was incorect'
    end
  end

  # Check for a win
  def game_won?
    secret_word_a.each do |letter|
      return false unless correct_letters_a.include?(letter)
    end
    true
  end

  # Print revealed letters in secret word & incorrect guesses
  def to_s
    secret_word = ''
    secret_word_a.each do |letter|
      secret_word += correct_letters_a.include?(letter) ? "#{letter} " : '_ '
    end

    "Secret word: #{secret_word}
Incorrect letters are: #{incorrect_letters_a.join(', ')}"
  end
end
