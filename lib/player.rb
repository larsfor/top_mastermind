# frozen_string_literal: true

# Game class that carries all the information and logic
class Player
  def initialize; end
end

# The human player
class HumanPlayer < Player
  def to_s
    'Is human'
  end
end

# The computer player
class ComputerPlayer < Player
  def to_s
    'Is computer'
  end
end
