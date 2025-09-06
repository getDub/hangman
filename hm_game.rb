require "yaml"

class Game

  attr_accessor :dictionary, :secret_word, :attempts_left, :all_guesses, :correct, :incorrect

  def initialize
    @dictionary = dictionary
    @secret_word = secret_word
    @attempts_left = 7
    @all_guesses = []
    @correct = []
    @incorrect = []
  end

  def start_game
    load_dictionary
    intro if correct.empty? && incorrect.empty?
    p @secret_word
    puts "Please see above game info of where you left off", game_info(@all_guesses.last) unless @all_guesses.empty?
    while @attempts_left > 0 
      game_info(guess)
      all_letters_revealed ? winner : save_this_game?
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

  def choose_secret_word
    @secret_word = valid_word_size.sample(1).first.upcase
  end
  
  def intro
    puts "Hi Player, welcome to Hangman."
    puts "Try and guess the secret word below one letter at a time."
    puts "If you think you know the word you can type it in."
    puts "However, if it is incorrect it will be counted as an attempt.\n\n"
    print "Take your first guess\n"
    choose_secret_word
    display_word
  end

  def game_info(player_input)
    puts "\n"
    display_word
    puts @attempts_left > 0 ? "Guesses remaining = #{@attempts_left}" : "Guesses remaining = 0"
    puts "Incorrect letters = #{@incorrect.join(", ")}"
    puts "Correct letters = #{@correct.join(", ")}"
    puts "\n"
  end

  def display_word
    print "secret word: ", secret_word.chars.map {|character| correct.include?(character) ? character : "_"}.join(" ")
    print"\n\n"
  end

  def guess
    guess = gets.chomp.upcase
    @all_guesses << guess

    save_as? if guess == "1"

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

  def spacer
      puts "__________________________________"
  end

  def winner
    @attempts_left = -1
    puts "Congrats...YOU win!"
  end

  def save_this_game?
    puts "Press 1 to Save Game"
  end

  def save_as?
    puts "Save as? Then press enter to save."
      file_name = gets.chomp
      save_game(file_name)
  end

  def save_game(file_name)
    Dir.mkdir("saves") unless Dir.exist?("saves")
    puts "file already exists" if File.exist?('file_name')
    current_game_data = YAML::dump(self)
    File.open("saves/#{file_name}.yaml", "w") {|f| f.write(current_game_data)}
    puts "Thank you. '#{file_name}' has been saved"
  end
 
  def self.load_game(saved_games_file)
    game_file = File.open("saves/#{saved_games_file}")
    yaml = game_file.read
    YAML::load(yaml, permitted_classes: [Game])
  end

end

def load_screen
  puts "Press [n] to start a new game"
  puts "Press [l] to load existing game"
  choice = gets.chomp.downcase
  if choice == "n"
    spacer
    start_new_game
  elsif choice == "l"
    spacer
    where_you_left_off
  end
end

def spacer
  print "\n___________________________________________________________\n"  
end

def start_new_game
  Game.new().start_game
end  

def where_you_left_off
  Game.load_game(saved_games).start_game
end
  
def saved_games
  puts "Saved games:"
  games = Dir.children("saves").each_with_index {|f, i| puts "    #{i + 1}. #{f.gsub(".yaml", "")}"}
  puts "Type the number of the game file you would like to load."
  file_number = gets.chomp.to_i - 1
  puts "    saved game '#{games[file_number].gsub(".yaml", "")}' loading...." 
  spacer
  games[file_number] 
end

load_screen