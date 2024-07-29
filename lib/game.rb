# frozen_string_literal: true

require_relative 'board'
require_relative 'player'

# Game class that carries all the information and logic
class Game
  attr_reader :board

  def initialize(role = '')
    @board = Board.new
    @round = 1
    @player = guesser_or_creator(role)
  end

  def start
    # print_rules
    ask_player_input('solution', 0, @player.role)
    puts "You're now playing as #{@player.role}."
    until @round > 12
      puts "Round #{@round}"
      ask_player_input('guesses', @round - 1, @player.role == 'guesser' ? 'creator' : 'guesser')
      board.give_feedback(@round)
      board.print_board(@round)
      return if game_over?

      @round += 1
    end
    puts "You didn't manage to find the correct combinations. If you want, you can try again! 😎"
  end

  def ask_player_input(place, round, player_type)
    guesses = []
    case player_type
    when 'guesser' then 4.times { guesses << %w[b y g p].sample }
    when 'creator' then 4.times { guesses << ask_for_color }
    else; puts 'Ask player input - Something went wrong.'; end

    place_colors(place, round, guesses)
  end

  def guesser_or_creator(role)
    return Player.new(role) if %w[guesser creator].include?(role)

    loop do
      puts 'Which role do you want to play - "guesser" or "creator".'
      answer = gets.chomp
      return Player.new(answer) if %w[guesser creator].include?(answer)

      puts 'Invalid option, please choose eiter "guesser" or "creator".'
    end
  end

  def game_over?
    return false unless @board.guesses[@round - 1] == @board.solution

    puts "Congratulations, you've chosen the correct combinations, and won! 🥳"
    true
  end

  def place_colors(place, round, colors)
    board = choose_board(place)
    if %w[guesses feedback].include?(place)
      colors.each_with_index { |c, i| board[round][i] = c }
    elsif %w[solution].include?(place)
      colors.each_with_index { |c, i| board[i] = c }
    else
      puts 'Place colors - Something went wrong.'; end
  end

  def choose_board(place)
    case place
    when 'guesses' then board = @board.guesses
    when 'feedback' then board = @board.feedback
    when 'solution' then board = @board.solution
    else; puts 'Choose board - Something went wrong.'; end
    board
  end

  def valid_color(color)
    %w[b y g p].include?(color)
  end

  def ask_for_color
    loop do
      puts 'Choose a color: [b]lue 🔵, [y]ellow 🟡, [g]reen 🟢 or [p]urple 🟣.' if @player.role == 'guesser'
      puts 'Pick four colors as a solution: [b]lue 🔵, [y]ellow 🟡, [g]reen 🟢 or [p]urple 🟣.' if @player.role == 'creator'
      color = gets.chomp
      return color if valid_color(color)

      puts 'Invalid color. Please try again.'
    end
  end

  def print_rules
    puts "
    In 12 rounds player one has to guess the correct combination of colors
    chosen by player two. The colors to choose from are:
    [b]lue 🔵, [y]ellow 🟡, [g]reen 🟢, and [p]urple 🟣.

    After each round of guessing, player one will get a feedback, where
    a white circle ⚪ means that one of the guessed color is correct, but in the wrong spot.
    A red circle 🔴 means that the guess color is correct and is in the correct spot.

    If player one manages to guess the correct combination and placement of colors in 12 or less
    rounds, this players wins.
    "
  end
end
