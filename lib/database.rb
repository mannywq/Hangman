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

  def save_state(game_class)
    filename = nil
    loop do
      filename = generate_filename
      File.exist?(filename) ? generate_filename : break
    end
    p filename
    data = Marshal.dump(game_class)
    puts 'Serialized data:'
    p data
    obj = Marshal.load(data)
    puts 'Unserialized data:'
    p obj.inspect.to_s
  end

  def generate_filename
    "#{ADJECTIVES.sample}=#{NOUNS.sample}"
  end
end
