class Game

  attr_accessor :dictionary, :secret_word, :correct, :incorrect

  
  def initialize
    @dictionary = dictionary
    @secret_word = secret_word
    @attempts = 7
    @letters_guessed = []
    @correct = []
    @incorrect = []
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
      @attempts -= 1
      game_display(guess)
      # all_letters_revealed
    end
    puts "\nYour out of turns. You loose." if @attempts == 0
    puts "The secret word was...#{@secret_word}"
  end

  def load_dictionary
    fname = 'dictionary.txt'
    @dictionary = File.readlines(fname, chomp: true)
  end

  def valid_word_size
    dictionary.select do |word|
      word.size >= 5 && word.size <= 12
    end
  end

  def game_display(letter)
    puts @attempts > 0 ? "\nGuesses remaining = #{@attempts}" : "Guesses remaining = 0"
    # puts remaining_guesses
    # puts "\nGuesses remaining = #{@attempts}"
    puts "Incorrect letters = #{@incorrect.join(", ")}"
    puts "Correct letters = #{@correct.join(", ")}"
    puts "\n"
    puts secret_word.chars.map {|character| correct.include?(character) ? character : "_"}.join(" ")
  end

  def display_word(word)
    no_of_spaces = word.size
    no_of_spaces.times do
      print " _"
    end
    print "\n\n"
  end

  def guess
    guess = gets.chomp.upcase
    # winning_guess?(guess) if guess.length > 1 
    if guess.length > 1
      winning_guess?(guess)
    elsif
      @secret_word.include?(guess)
      @correct << guess
    # if @secret_word.include?(guess)
      # @correct << guess 
    else
      @incorrect << guess
    end
  end

   def winning_guess?(word)
    if word.eql?(@secret_word)
      @attempts = -1
      puts "\nYOU WIN"
      @correct = word#.split("")
      puts "correct is#{@correct}"
    # elsif word.eql?(true)
    #   @attempts = -1
    #   puts "Solved! The secrect word is #{@secret_word}"
    else
      puts "\nIncorrect word"
      @incorrect << word#.split("")
    end
  end

  def all_letters_revealed
     puts "Solved! The secrect word is #{@secret_word}" if @secret_word.chars.all? {|character| @correct.include?(character)}
    @attempts = -1
  end

  
    
end

hm = Game.new
hm.start_game
