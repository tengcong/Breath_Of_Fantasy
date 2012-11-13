class Character

  attr_accessor :power
  attr_accessor :energy
  attr_accessor :role

  def initialize power, energy, role="hero"
    @power = power
    @energy = energy
    @role = role
  end

  def attack other
    other.under_attack self
  end

  def under_attack by_who
    set_energy_with caculated_damage_from(current_luck, by_who)
  end

  def set_energy_with damage
    @energy -= damage
  end

  def caculated_damage_from luck, by_who
    if (0..3).include? luck
      0
    elsif (4..70).include? luck
      by_who.power / 3
    elsif (71..96).include? luck
      by_who.power / 3 * 1.2
    else
      by_who.power * 2
    end
  end

  def current_luck
    (0..100).to_a.shuffle.first
  end
end
