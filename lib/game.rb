# frozen_string_literal: true

require 'yaml'
# require '.dictionary'
# hangman game
class Game
  attr_accessor :dictionary, :secret_word, :attempts_left, :all_guesses, :correct, :incorrect

  def initialize
    @dictionary = load_dictionary
    @secret_word = secret_word
    @attempts_left = 7
    @all_guesses = []
    @correct = []
    @incorrect = []
  end

  def start_game
    intro if correct.empty? && incorrect.empty?
    # p @secret_word #enable when testing
    unless @all_guesses.empty?
      game_info
      print "    Please see above game info of where you left off.\nTake your next guess\n"
    end
    while @attempts_left.positive?
      prompt_players_guess
      game_info
      all_letters_revealed ? winner : save_this_game?
    end
    turn_tracker
  end

  def load_dictionary
    fname = 'dictionary.txt'
    @dictionary = File.readlines("lib/#{fname}", chomp: true)
  end

  def valid_word_size
    dictionary.select do |word|
      word.size >= 5 && word.size <= 12
    end
  end

  def choose_secret_word
    @secret_word = valid_word_size.sample(1).first.upcase
  end

  def turn_tracker
    puts 'Your out of turns. You loose.' if @attempts_left.zero?
    puts "The secrect word was #{@secret_word}"
  end

  def intro
    print "Welcome to Hangman.\nTry and guess the secret word below one letter at a time.\n"
    print "If you think you know the word you can type it in.\nHowever, if it is incorrect it will be counted as an attempt.\n\n"
    print "Take your first guess\n\n"
    choose_secret_word
    display_word
    spacer
  end

  def game_info
    puts "\n"
    display_word
    puts @attempts_left.positive? ? "Guesses remaining = #{@attempts_left}" : 'Guesses remaining = 0'
    puts "Incorrect letters = #{@incorrect.join(', ')}\nCorrect letters = #{@correct.join(', ')}\n"
  end

  def display_word
    print 'secret word: ', secret_word.chars.map { |character| correct.include?(character) ? character : '_' }.join(' ')
    print "\n\n"
  end

  def prompt_players_guess
    guess = gets.chomp.upcase
    @all_guesses << guess
    process_answer(guess)
  end

  def process_answer(guess)
    if guess.length > 1
      word_guess(guess)
    elsif guess.to_i > 1
      puts '    Your guess needs to be a letter not a number.'
    elsif guessed_already(guess)
      puts "    You've guessed this already"
    elsif @secret_word.include?(guess)
      puts "    #{guess} is correct"
      @correct << guess
    elsif guess == '1'
      save_as?
    else
      @attempts_left -= 1
      puts "    #{guess} is incorrect"
      @incorrect << guess
    end
  end

  def guessed_already(players_guess)
    @correct.include?(players_guess) || @incorrect.include?(players_guess)
  end

  def word_guess(word)
    if word.eql?(@secret_word)
      @correct = word.split('')
    else
      puts "    \n #{word} is the incorrect word unfortunately"
      @attempts_left -= 1
      @incorrect << word
    end
  end

  def all_letters_revealed
    @secret_word.chars.all? { |character| @correct.include?(character) }
  end

  def spacer
    puts '__________________________________'
  end

  def winner
    @attempts_left = -1
    puts 'Congrats...YOU win!'
  end

  def save_this_game?
    puts 'Press 1 to Save Game'
    spacer
  end

  def save_as?
    puts 'Save as? Then press enter to save.'
    file_name = gets.chomp
    save_game(file_name)
  end

  def save_game(file_name)
    Dir.mkdir('lib/saves') unless Dir.exist?('lib/saves')
    puts 'file already exists' if File.exist?('file_name')
    current_game_data = YAML.dump(self)
    File.open("lib/saves/#{file_name}.yaml", 'w') { |f| f.write(current_game_data) }
    puts "Thank you. '#{file_name}' has been saved"
  end

  def self.load_game(saved_games_file)
    game_file = File.open("lib/saves/#{saved_games_file}")
    yaml = game_file.read
    puts "#{saved_games_file} now loading...."
    YAML.safe_load(yaml, permitted_classes: [Game])
  end
end

