# frozen_string_literal: true

require_relative 'lib/game'
require_relative 'lib/player'

def main
  game = Game.new
  game.start
end

main
