class Engine
  def initialize how_many_enemies = 1
    @hero = create_hero
    @enemies = create_enemies(how_many_enemies)
    @enemies_count = how_many_enemies
    @counter = -1
  end

  def main
    fight_order = create_fight_order
    until over?
      start_fight fight_order
    end
    who_win
  end

  def start_fight fight_order
    members_count.times do
      current = self.next(fight_order)
      next if current.died? || over?
      if current.role == "hero"
        @enemies.select(&:alive).each{|e| current.attack e}
      elsif current.role == "enemy"
        current.attack @hero
      end
      p '-' * 10
    end
  end

  def members_count
    @enemies_count + 1
  end

  def who_win
    puts 'enemies win!' if @hero.died?
    puts 'hero win!' if @enemies.all?(&:died?)
  end

  def over?
    @hero.died? || @enemies.all?(&:died?)
  end

  def next fight_order
    @counter += 1
    origin_characters = [@hero, @enemies].flatten
    characters = origin_characters.sort_by do |character|
      fight_order.index(origin_characters.index(character))
    end

    cursor = @counter % characters.count
    characters[cursor]
  end

  def create_fight_order
    (0..@enemies_count).to_a.shuffle
  end

  def create_hero
    Character.new 100, 200, 'hero'
  end

  def create_enemies how_many_enemies
    [].tap do |arr|
      how_many_enemies.times{ arr << Character.new(100, 100, 'enemy') }
    end
  end

end
