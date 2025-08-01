class Game

  attr_accessor :dictionary, :secret_word, :guesses_left, :letters_chosen

  MAX_ATTEMPTS = 7 

  def initialize
    @dictionary = dictionary
    @secret_word= secret_word
    @incorrect_guesses = []
    @letters_guessed = []
  end

  def start_game
    load_dictionary
    puts "Hi Player, welcome to Hangman."
    puts "Try and guess the secret word below one letter at a time.\n\n"
    display_word(@secret_word = valid_word_size.sample(1).first.upcase)
    puts "You have #{MAX_ATTEMPTS} guesses left"
    p @secret_word
      MAX_ATTEMPTS.times do
        puts "\nchoose a letter"
        correct_letter?(guesses)
      end
  end

  def load_dictionary
    fname = 'dictionary.txt'
    @dictionary = File.readlines(fname, chomp: true)
  end

  def valid_word_size
    @dictionary.select do |word|
      word.size >= 5 && word.size <= 12
    end
  end

  def display_word(word)
    no_of_spaces = word.size
    no_of_spaces.times do
      print " _"
    end
    print "\n\n"
  end

  def guesses
    guess = gets.chomp.upcase
    p "guess looks like this: #{guess.class}"
    @letters_guessed << guess #unless @secret_word.include?(guess)
    puts "You have guessed these letters - #{@letters_guessed.join(", ")}"    
    # guess
    p "letter guessed looks like this: #{@letters_guessed.class}"
    @letters_guessed
  end

  def correct_letter?(letter)
    p "letters entering correct letter : #{letter}"
    puts @secret_word.chars.map {|character| letter.include?(character) ? character : "_"}.join(" ")
  end

  
  
end

hm = Game.new
hm.start_game
