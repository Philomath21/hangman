class Game
  attr_accessor :secret_word_a, :correct_letters_a, :incorrect_letters_a, :life_i

  def create_dictionary_a
    # Reading dictiory file as array of words
    dictionary_a = File.readlines "google-10000-english-no-swears.txt"
    # Removing \n (whitespaces) from words
    dictionary_a.map! { |word| word.strip}
    # Selecting words having 5 to 12 characters
    dictionary_a.select! { |word| (5..12).include? word.length  }
  end

  def initialize
    @dictionary_a = self.create_dictionary_a

    # Selecting a secret word,i.e a random word from dictionary
    # And storing it in array format
    @secret_word_a = @dictionary_a.sample.split("")

    # Wrong guesses remaining?
    @life_i = 5

    # Correct & incorrect guesses made by the player
    @correct_letters_a = []
    @incorrect_letters_a = []
  end

  # Player makes a guess of letter
  def make_a_guess
    puts "Guess a letter"
    while true
      # making it case insensitive & validating it
      guess = gets.chomp.downcase
      break if guess.length == 1 && guess.match?(/[A-Za-z]/)
      puts "Please enter a valid alphabet"
    end
    guess
  end

  # Check if guess is correct or incorrect
  def check_guess(guess)
    if self.secret_word_a.include?(guess)
      self.correct_letters_a.push(guess)
      puts "Your guess was correct!"
    else
      self.incorrect_letters_a.push(guess)
      puts "Your guess was incorect"
    end
  end

  def to_s
    secret_word = ""
    self.secret_word_a.each do |letter|
      secret_word += self.correct_letters_a.include?(letter) ?  "#{letter} " : "_ "
    end

    "Secret word: #{secret_word}
Incorrect letters are: #{self.incorrect_letters_a.join(", ")}"
  end
end
