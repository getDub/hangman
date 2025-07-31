class Game

  attr_accessor :dictionary, :secret_word, :guesses_left, :letters_chosen

  MAX_ATTEMPTS = 7 

  def initialize
    @dictionary = dictionary
    @secret_word= secret_word
    @incorrect_guesses = []
    @correct_guesses = []
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
        correct_letter?(letter_guessed)
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

  def letter_guessed
    guess = gets.chomp.upcase
    @correct_guesses << guess unless @secret_word.include?(guess)
    puts "You have guessed these letters - #{@correct_guesses.join(", ")}"    
    guess
  end

  def correct_letter?(letter)
    puts @secret_word.chars.map {|character| letter.include?(character) ? character : "_"}.join(" ")
  end

  
  
end

hm = Game.new
hm.start_game
