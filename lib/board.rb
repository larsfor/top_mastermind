# frozen_string_literal: true

require_relative 'game'

# Game class that carries all the information and logic
class Board
  attr_reader :guesses, :feedback, :solution

  def initialize
    @guesses = Array.new(12) { Array.new(4) }
    @feedback = Array.new(12) { Array.new(0) }
    @solution = Array.new(4)
  end

  def markers
    @markers = {
      b: '🔵',
      y: '🟡',
      g: '🟢',
      p: '🟣',
      w: '⚪',
      r: '🔴'
    }
  end

  def give_feedback(round)
    # placing red markers
    place_red(round, @guesses[round - 1], @solution)
    # placing white markers
    place_white(round, @guesses[round - 1], @solution)
  end

  def place_red(round, guess, solution)
    (0...4).each { |i| @feedback[round - 1] << :r if guess[i] == solution[i] }
  end

  def place_white(round, guess, solution)
    red_count = @feedback[round - 1].count(:r)
    white_count = 0
    (0...4).each do |i|
      if solution.include?(guess[i]) && red_count.positive?
        red_count -= 1
      elsif solution.include?(guess[i]) && red_count <= 0 && white_count <= solution.count(guess[i])
        @feedback[round - 1] << :w
        white_count += 1
      end
    end
  end

  def color_board(round)
    guesses = []
    feedback = []
    (0...round).each do |i|
      guesses << @guesses[i].map { |c| markers[c.to_sym] }
      feedback << @feedback[i].map { |c| markers[c.to_sym] }
    end
    [guesses, feedback]
  end

  def print_board(round)
    color_guesses, color_feedback = color_board(round)
    # print 'Solution: '
    # (0...4).each { |i| print markers[@solution[i].to_sym] + ' ' }
    # puts "\n"
    puts 'Your guesses:  |   Feedback:'
    puts '-----------------------------'
    (0..round - 1).each do |i|
      puts "#{color_guesses[i].join(' ')}    |   #{color_feedback[i].join(' ')}"
    end
    puts "\n"
  end
end
