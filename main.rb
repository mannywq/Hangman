require_relative './lib/hangman'

game = Game.new
puts game.logo
game.game_start

until game.tries.zero?
  game.display_word
  game.make_guess
end

game.game_over? ? game.win : game.lose
