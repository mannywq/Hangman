require 'time'

module Database
  # Arrays of adjectives and nouns
  ADJECTIVES = [
    'Cheerful',
    'Tranquil',
    'Mystic',
    'Radiant',
    'Vibrant',
    'Graceful',
    'Dazzling',
    'Enchanted',
    'Elegant',
    'Captivating'
  ].freeze

  NOUNS = [
    'Explorer',
    'Serenity',
    'Whisper',
    'Harmony',
    'Vision',
    'Blossom',
    'Cascade',
    'Tranquility',
    'Horizon',
    'Starlight'
  ].freeze

  def data_path
    File.join(__dir__, '.data')
  end

  def setup_data_dir
    Dir.mkdir('.data')
    p 'Created directory .data'
  end

  def load_saves
    setup_data_dir unless Dir.exist?(data_path)
    saves = []

    Dir.foreach(data_path) { |file| saves << file }

    @saves = saves.select { |save| save.chars.none?('.') }
    # p @saves
  end

  def load_state(filename)
    data = nil
    puts "#{data_path}/#{filename}"
    if File.exist?("#{data_path}/#{filename}")
      File.open("#{data_path}/#{filename}", 'r') do |file|
        data = Marshal.load(file)
      end
    else
      puts 'Problem opening file'
      return
    end

    if !data.nil?
      @guess = data.guess
      @guesses = data.guesses
      @display = data.display
      @fails = data.fails
      @game_str = data.game_str
      @tries = data.tries
      puts "#{filename} loaded"
    else
      puts "Failed to load data from #{filename}"
    end
  end

  def save_state(game_class)
    filename = generate_filename

    data = Marshal.dump(game_class)
    f = File.open("#{data_path}/#{filename}", 'w')
    f.write(data)
    f.close
    puts "Data saved #{data} to #{filename}"
    exit
  end

  def generate_filename
    "#{ADJECTIVES.sample}-#{NOUNS.sample}-#{Time.now.strftime('%y-%m-%d-%H-%M-%S')}".downcase
  end
end
