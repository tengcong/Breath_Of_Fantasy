class Engine
  def initialize how_many_enemies = 1
    @hero = create_hero
    @enimies = create_enemies(how_many_enemies)
    @enemies_count = how_many_enemies
    @counter = -1
  end

  def start_fight
    @enimies.each do |enemy|
      enemy.attack(@hero)
      @hero.attack(enemy)
    end
  end

  def next
    @counter += 1
    origin_characters = [@hero, @enimies].flatten
    characters = origin_characters.sort_by do |character|
      create_fight_order.index(origin_characters.index(character))
    end

    cursor = @counter % characters.count
    characters[cursor]
  end

  def create_fight_order
    (0..@enemies_count).to_a.shuffle
  end

  def create_hero
    Character.new 200, 200, 'hero'
  end

  def create_enemies how_many_enemies
    [].tap do |arr|
      how_many_enemies.times{ arr << Character.new(200, 200, 'enemy') }
    end
  end

end
