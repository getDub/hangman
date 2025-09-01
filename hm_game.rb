require "yaml"

class Game

  attr_accessor :dictionary, :secret_word, :attempts_left, :correct, :incorrect
  
  def initialize
    @dictionary = dictionary
    @secret_word = secret_word
    @attempts_left = 7
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
    while @attempts_left > 0 
      game_info(guess)
      all_letters_revealed ? winner : press1
      puts "__________________________________"
    end
    puts "\nYour out of turns. You loose." if @attempts_left == 0
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
    puts @attempts_left > 0 ? "Guesses remaining = #{@attempts_left}" : "Guesses remaining = 0"
    puts "Incorrect letters = #{@incorrect.join(", ")}"
    puts "Correct letters = #{@correct.join(", ")}"
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

    if guess == "1"
      puts "Save as?"
      file_name = gets.chomp
      save_game(file_name)
    elsif guess == "2"
      # game = Game.new().load_game(saved_game)
      # new_game = Game.new()
      # new_game.load_game(saved_game)
      
    end
    
    puts "you've guessed this already" if guessed_already(guess)

    if guess.length > 1
      word_guess(guess)
    elsif @secret_word.include?(guess)
      puts "#{guess} is correct"
      @correct << guess
    else
      @attempts_left -= 1 
      puts "#{guess} is incorrect"
      @incorrect << guess
    end
  end

  def guessed_already(players_guess)
    @correct.include?(players_guess) || @incorrect.include?(players_guess)
  end

   
  def word_guess(word)
    if word.eql?(@secret_word)
      @correct = word.split("")
    else
      puts "\n #{word} is the incorrect word unfortunately"
      @attempts_left -= 1
      @incorrect << word
    end
  end

  def all_letters_revealed
     @secret_word.chars.all? {|character| @correct.include?(character)}
  end

  def winner
    @attempts_left = -1
    puts "Congrats...YOU win!"
  end

  def press1
    puts "Press 1 to Save Game"
  end

  def saved_game
    games = Dir.children("saves").each_with_index {|f, i| puts "#{i + 1}. #{f}"}
    puts "type the number of the game file you would like to load."
    file_number = gets.chomp.to_i #+ 1
    puts games[file_number] 
    games[file_number] 
  end
  
  def save_game(file_name)
    Dir.mkdir("saves") unless Dir.exist?("saves")
    puts "file already exists" if File.exist?('file_name')
    current_game_data = YAML::dump(self)
    # p current_game_data
    File.open("saves/#{file_name}.yaml", "w") {|f| f.write(current_game_data)}
    puts "Thank you. '#{file_name}' has been saved"
  end
 
  def self.load_game(saved_game_file)
    puts "Game file received in load game: #{saved_game_file}"
    # YAML.load_file("saves/#{saved_game_file}", permitted_classes: [Game])
    game_file = File.new("saves/#{saved_game_file}")
    yaml = game_file.read
    loaded_data = YAML::load(yaml, permitted_classes: [Game])
    puts loaded_data
    # Game.new(loaded_data)
  end

end

# hm = Game.new
# hm.start_game
# start_game
# 
new_game = Game.new()
new_game.load_game(saved_game)