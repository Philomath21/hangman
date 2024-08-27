# Reading dictiory file as array of words
dictionary = File.readlines "google-10000-english-no-swears.txt"

# Removing \n (whitespaces) from words
dictionary.map! { |word| word.strip}

# Selecting words having 5 to 12 characters
dictionary.select! { |word| (5..12).include? word.length  }

# Selecting a secret word,i.e a random word from dictionary
# And storing it in array format
secret_word_a = dictionary.sample.split("")

# Player makes a guess of letter
# making it case insensitive & validating it
puts "Guess a letter"
while true
  guess = gets.chomp.downcase
  break if guess.length == 1 && guess.match?(/[A-Za-z]/)
  puts "Please enter a valid alphabet"
end

# Wrong guesses remaining?
life = 5

# Display: _ r o g r a _ _ i n g
correct_letters_a = []
# logic

# Display incorrect letters guessed also
incorrect_leters_a = []

# Check if guess is correct or incorrect
if secret_word_a.include?(guess)
  correct_letters_a.push(guess)
  puts "Your guess was correct!"
else
  incorrect_leters_a.push(guess)
  puts "Your guess was incorect"
end
