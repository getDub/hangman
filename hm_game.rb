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
    # @secret_word = valid_word_size.sample(1).first.upcase
    p @secret_word
    while @attempts > 0 
      game_info(guess)
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

  def game_info(player_input)
    puts "\n"
    puts secret_word.chars.map {|character| correct.include?(character) ? character : "_"}.join(" ")
    puts @attempts > 0 ? "Guesses remaining = #{@attempts}" : "Guesses remaining = 0"
    puts "Incorrect letters = #{@incorrect.join(", ")}"
    puts "Correct letters = #{@correct.join(", ")}"
    # puts "Correct letters = #{@correct}"
    puts "\n"
  end

  def display_word(word)
    word.length.times do
      print " _"
    end
    print "\n\n"
  end

  def guess
    guess = gets.chomp.upcase
    # winning_guess?(guess) if guess.length > 1 
    puts "you've guessed this already" if guessed_already(guess)
    if guess.length > 1
      winning_guess?(guess)
    elsif
      @secret_word.include?(guess)
      @correct << guess
    # if @secret_word.include?(guess)
      # @correct << guess 
    else
      @attempts -= 1 
      @incorrect << guess
    end
  end

  def guessed_already(players_guess)
    @correct.include?(players_guess) || @incorrect.include?(players_guess)
  end

   def winning_guess?(word)
    if word.eql?(@secret_word)
      @attempts = -1
      puts "\nYOU WIN"
      @correct = word.split("")
      # @correct << word
      # puts "correct is#{@correct}"
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
