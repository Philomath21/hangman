require 'msgpack'

# returns hash containing parameters to create a new Game class object
def new_game_para_hash
  # Creating dictionary array as per given condition in project
  # Reading dictiory file as array of words
  # Removing \n (whitespaces) from words
  # Selecting words having 5 to 12 characters

  dictionary_a = File.readlines 'google-10000-english-no-swears.txt'
  dictionary_a.map!(&:strip)
  dictionary_a.select! { |word| (5..12).include? word.length }

  {
    # Selecting a secret word,i.e a random word from dictionary & storing it in array format
    'secret_word_a' => dictionary_a.sample.split(''),
    'life_i' => 7,                # Wrong guesses remaining?
    'correct_letters_a' => [],    # Correct guesses made by the player
    'incorrect_letters_a' => []   # Incorrect guesses made by the player
  }
end

# class Game, create new object for a new game
class Game
  attr_accessor :secret_word_a, :life_i, :correct_letters_a, :incorrect_letters_a

  def initialize(hash = new_game_para_hash)
    self.secret_word_a       = hash['secret_word_a']
    self.life_i              = hash['life_i']
    self.correct_letters_a   = hash['correct_letters_a']
    self.incorrect_letters_a = hash['incorrect_letters_a']
  end

  # Loads game from previously saved .msgpack file by unpacking it
  # User can select from any of the saved games
  # returns game object with parameters from the saved file
  def self.load_game
    filesname_a = Dir.glob('save/*.msgpack') # Lists all save files, stores in array

    puts 'Select the game from saved files: '
    filesname_a.each_with_index { |name, index| puts "#{index} > #{name.sub('save/', '').sub('.msgpack', '')}" }
    puts ' Please enter the index number of save file : '
    begin
      index = gets.chomp
      savefile_name = filesname_a[index.to_i]
    rescue StandardError
      puts 'Incorrect entry. Please enter a valid index number of save file : '
      retry
    end

    savefile = File.binread(savefile_name)
    savefile_hash = MessagePack.unpack(savefile) # savefile_hash
    new(savefile_hash)
  end

  # Checks for a win (secret word guessed completely), returns true or false
  def game_won?
    secret_word_a.each do |letter|
      return false unless correct_letters_a.include?(letter)
    end
    puts "The secret word was : #{secret_word_a.join(' ')}"
    puts 'CONGRATULATIONS! You have won the game!'
    true
  end

  # Checks for game over (life_i == 0), returns true or false
  def game_over?
    return false unless life_i.zero?

    puts "The secret word was : #{secret_word_a.join(' ')}"
    puts 'No chances remaining. GAME OVER!'
    true
  end

  # Prints current game status:
  # 1. Revealed letters in secret word
  # 2. Incorrect guesses of letters
  # 3. Chances remaining
  def to_s
    word = ''
    secret_word_a.each do |letter|
      word += correct_letters_a.include?(letter) ? "#{letter} " : '_ '
    end

    "Secret word: #{word}
Incorrect letters are: #{incorrect_letters_a.join(', ')}
Chances remaining: #{life_i}"
  end

  # Lets user make a letter guess, returns guess
  def make_a_guess
    puts "Press '0' to save the current game. Please guess a letter : "
    loop do # Loop continues till user enters a valid input
      guess = gets.chomp.downcase # making it case insensiive

      if (correct_letters_a + incorrect_letters_a).include? guess
        puts 'You have already entered this alphabet, please enter a new alphabet'
      elsif guess.match?(/[[:alpha:]]/) && guess.length == 1
        return guess
      elsif guess == '0'
        return guess
      else
        puts 'Please enter a valid alphabet'
      end
    end
  end

  # Saves game on pressing 0, serializes parameters hash using MessagePack
  # returns true or false
  def asked_to_save_game?(guess)
    return false unless guess == '0'

    Dir.mkdir('save') unless Dir.exist?('save')
    puts 'Rename save game as : '
    savefile_name = gets.chomp.downcase

    savefile_hash = {
      'secret_word_a' => secret_word_a,
      'life_i' => life_i,
      'correct_letters_a' => correct_letters_a,
      'incorrect_letters_a' => incorrect_letters_a
    }
    savefile = MessagePack.pack(savefile_hash)
    File.binwrite("save/#{savefile_name}.msgpack", savefile)

    puts 'Game saved successfully!'
    true
  end

  # Checks if the letter guess is correct or incorrect, returns nil
  # Reduces life by 1 on incorrect letter guess
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
end
