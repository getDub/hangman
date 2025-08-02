class Game

  attr_accessor :dictionary, :secret_word, :guesses_left, :letters_chosen

  
  def initialize
    @dictionary = dictionary
    @secret_word= secret_word
    @attempts = 7
    @letters_guessed = []
  end

  def start_game
    load_dictionary
    puts "Hi Player, welcome to Hangman."
    puts "Try and guess the secret word below one letter at a time."
    puts "If you think you know the word you can type it in."
    puts "However, if it is incorrect it will be counted as an attempt.\n\n"
    puts "Take your first guess\n"
    display_word(@secret_word = valid_word_size.sample(1).first.upcase)
    p @secret_word
    while @attempts > 0
      if @attempts < 7
        puts "\nGuesses remaining = #{@attempts}"
        puts "Letters guessed =  #{@letters_guessed.join(", ")}"
        puts "Guess again"
      end
      correct_letter?(guesses)
      @attempts -= 1
    end
    puts "\nYou loose."
    puts "The secret word was...#{@secret_word}"
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
    win?(guess) if guess.length > 1 
    @letters_guessed << guess 
    @letters_guessed
  end

  def correct_letter?(letter)
    puts "\n"
    puts @secret_word.chars.map {|character| letter.include?(character) ? character : "_"}.join(" ")
  end

  def win?(word)
    if word.eql?(@secret_word)
      @attempts = 0
      puts "You win"
      @letters_guessed = word.split("")
    else
      puts "\nIncorrect word\n"
    end
    word
  end
  
end

hm = Game.new
hm.start_game
