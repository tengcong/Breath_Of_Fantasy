class Engine
  def initialize how_many_enemies = 1
    @hero = create_hero
    @enimies = create_enemies(how_many_enemies)
    @counter = -1
  end

  def next
    @counter += 1

    characters = [@hero, @enimies].flatten

    cursor = @counter % characters.count
    characters[cursor]
  end

  def create_hero
    Character.new 200, 200, 'hero'
  end

  def create_enemies how_many_enemies
    [].tap do |arr|
      how_many_enemies.times{ arr << Character.new(50, 50, 'enemy') }
    end
  end

end
