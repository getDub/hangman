# frozen_string_literal = true
require 'yaml'
# this class is the load screen to the game
class LoadScreen
  def splash_screen
    print "------ HANGMAN ------\n"
    puts 'Press [n] to start a new game'
    puts 'Press [l] to load existing game'
    switch_to_selection(player_input)
  end

  def player_input
    gets.chomp.downcase
  end

  def error_handling(input)
    until input.eql?('n') || input.eql?('l')
      print "Your selection must be either [n] or [l].\n Try again>>  "
      input = player_input
    end
    switch_to_selection(input)
  end

  def switch_to_selection(selection)
    case selection
    when 'n'
      spacer
      start_new_game
    when 'l'
      spacer
      where_you_left_off
    else
      error_handling(selection)
    end
  end

  def spacer
    print "\n___________________________________________________________\n"
  end

  def start_new_game
    Game.new.start_game
  end

  def where_you_left_off
    # Game.load_game(saved_games).start_game if no_saved_games
    Dir.exist?('lib/saves') ? Game.load_game(saved_games).start_game : no_saved_games
  end
  
  def no_saved_games
    puts 'Sorry, no saved games' # unless Dir.exist?('lib/saves')
    puts 'Choose [n] to start a new game.'
    switch_to_selection(player_input)
  end

  def saved_games
    puts 'Saved games:'
    games = Dir.children('lib/saves').each_with_index { |file, idx| puts "    #{idx + 1}. #{file.gsub('.yaml', '')}" }
    puts 'Type the number of the game file you would like to load.'
    file_number = gets.chomp.to_i - 1
    puts "file number is #{file_number}"
    puts "games length = #{games.length}"
    while file_number > games.length || file_number.eql?(-1)
      puts 'Incorrect number. Please select from the numbers displayed to the left of the file'
      file_number = gets.chomp.to_i - 1
    end
    puts "    you've selected '#{games[file_number].gsub('.yaml', '')}' to load."
    spacer
    games[file_number]
  end
end
