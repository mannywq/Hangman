require_relative './database'
require_relative './display'

class Game
  attr_accessor :word, :tries, :guess, :guesses, :game_str, :fails, :display

  include Database
  include Display

  def initialize
    @tries = 7
    @word = load_data
    @game_str = ''
    @guess = nil
    @guesses = []
    @fails = []
    @display = []

    load_saves
  end

  def load_data
    dir = __dir__
    path = File.join(dir, 'data.txt')
    words = nil
    File.open(path, 'r') do |file|
      words = File.readlines(file)
    end

    shortlist = words.select { |word| word.length > 4 && word.length < 13 }

    shortlist.sample.chomp
  end

  def game_start
    puts welcome
    @saves.each_with_index { |save, idx| puts "#{idx + 1}) #{save}" }
    prompt_mode
  end

  def prompt_mode
    print 'Choose an option: '
    mode = gets.chomp
    if mode == 's'
      system('clear')
      nil
    elsif mode.to_i >= 1 && mode.to_i <= @saves.length
      idx = mode.to_i - 1
      save = @saves[idx]
      load_state(save)
    else
      prompt_mode
    end
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

    puts str.join(' ')
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

  def make_guess
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
