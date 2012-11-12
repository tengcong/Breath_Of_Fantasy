class Engine
  def initialize tim, tom
    @tim, @tom = tim, tom
    @turns = -1
  end
  def start_fight
    get_first_index

    @tim.attack
  end

  def get_first_index
    return @turns += 1
  end

  def set_position
    [@tim, @tom]
  end

end
