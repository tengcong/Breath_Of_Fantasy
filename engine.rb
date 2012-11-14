class Engine
  def initialize how_many_enemies = 1
    @hero = create_hero
    @enimies = create_enemies(how_many_enemies)
    @enemies_count = how_many_enemies
    @counter = -1
  end


  def start_fight
    (@enemies_count + 1).times do
      current = self.next
      if current.role == "hero"
        current.attack @enimies.first
      elsif current.role == "enemy"
        current.attack @hero
      end
    end
  end

  def next
    @counter += 1
    origin_characters = [@hero, @enimies].flatten
    new_order = create_fight_order
    characters = origin_characters.sort_by do |character|
      new_order.index(origin_characters.index(character))
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
