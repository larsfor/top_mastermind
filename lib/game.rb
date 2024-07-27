# frozen_string_literal: true

require_relative 'board'

# Game class that carries all the information and logic
class Game
  attr_reader :board

  def initialize
    @board = Board.new
    @round = 1
    @player = nil
  end

  def start
    # print_rules
    ask_player_input('solution', @round - 1, 'computer')
    # # @player = @player == 'human' ? 'computer' : 'human'
    @player = 'computer'
    until @round > 12
      # until @round > 2
      puts "Round #{@round}"
      ask_player_input('guesses', @round - 1, @player)
      board.give_feedback(@round)
      board.print_board(@round)
      return if game_over?

      @round += 1
    end
    puts "You didn't manage to find the correct combinations. If you want, you can try again! 😎"
  end

  def game_over?
    return false unless @board.guesses[@round - 1] == @board.solution

    puts "Congratulations, you've chosen the correct combinations, and won! 🥳"
    true
  end

  def ask_player_input(place, round, player_type)
    guesses = []
    case player_type
    when 'computer' then 4.times { guesses << %w[b y g p].sample }
    when 'human' then 4.times { guesses << board.ask_for_color }
    else; puts 'Ask player input - Something went wrong.'; end

    place_colors(place, round, guesses)
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
