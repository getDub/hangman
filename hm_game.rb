class Game

  attr_accessor :dictionary, :secret_word, :guesses_left, :letters_chosen

  MAX_ATTEMPTS = 7 

  def initialize
    @dictionary = dictionary
    @secret_word = secret_word
    @guesses_left = guesses_left
    @letters_chosen = ["none"]
    @correct_guesses = []
  end

  def start_game
    load_dictionary
    puts "Hi Player, welcome to Hangman."
    puts "Try and guess the secret word below one letter at a time.\n\n"
    letter_spaces(@secret_word = valid_word_size.sample(1).first)
    puts "You have #{turns_left} guesses left"
    p @secret_word
      turns_left.times do
        # p @letters_chosen
        puts "choose a letter"
        # p @letters_chosen
        correct_letter?(letter = gets.chomp)
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

  def letter_spaces(word)
    no_of_spaces = word.size
    no_of_spaces.times do
      print " _"
    end
    print "\n\n"
  end

  def display_word
    @secret_word
  end

  def turns_left
     @guesses_left = @secret_word.size
  end

  # def letter_correct?(letter)
  #   if @secret_word.include?(letter)
  #     puts " #{letter}"
  #   else
  #     puts " _"
  #   end
  # end

  # def correct_letter?(letter)
  #   @secret_word.split("").map do |character|
  #     if letter == character
  #       print " #{character}"
  #       # print character
  #     elsif letter != character
  #       print character = " _"
  #     end
  #   end
  # end

  def correct_letter?(letter)
    puts @secret_word.chars.map {|character| letter.include?(character) ? character : "_"}.join(" ")
  end
  # def correct_letter?(letter)
  #   @secret_word.split("").map do |character|
  #     print character = "_ " unless letter == character
  #     # @correct_guesses << character
  #     print character
  #   end
  # end

end

hm = Game.new
hm.start_game
