require './database'

class Game
  attr_reader :word, :tries

  include Database

  def initialize
    @tries = 7
    @word = load_data
    @game_str = ''
    @guess = nil
    @guesses = []
    @fails = []
    @display = []
  end

  def load_data
    f = File.open('./data.txt', 'r')

    words = File.readlines(f)

    shortlist = words.select { |word| word.length > 4 && word.length < 13 }

    shortlist.sample.chomp
  end

  def display_word
    str = []

    @word.chars.each_with_index do |c, i|
      str << if @display.any?(i)
               c
             else
               '_'
             end
    end

    @game_str = str.join('')

    win if game_over?

    print str.join(' ')
    puts
  end

  def game_over?(guess = @game_str)
    # puts "Comparing #{@game_str} with #{@word}"
    guess == @word
  end

  def win
    puts "#{@word} is correct! You win!"
    exit
  end

  def lose
    puts "You're out of tries. The correct word was #{@word}"
    exit
  end

  def guess
    puts "Guesses left: #{@tries}"
    puts "Failed guesses: #{@fails.join(' ')}"
    print 'Guess a letter or type save to save your game: '
    @guess = gets.chomp

    @guess == 'save' ? save_state(self) : check_guess(@guess)
  end

  def check_guess(guess)
    hits = []
    win if game_over?(guess)
    word.chars.each_with_index do |c, i|
      hits << i if guess == c
    end
    if hits.none?
      @tries -= 1
      @fails << guess
    end
    hits.each { |hit| @display << hit }
  end
end

game = Game.new

until game.tries.zero?
  game.display_word
  game.guess
end

game.game_over? ? game.win : game.lose
