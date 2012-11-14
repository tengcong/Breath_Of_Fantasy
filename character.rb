require_relative "game_helper"
class Character

  attr_accessor :power
  attr_accessor :energy
  attr_accessor :role

  include GameHelper

  def initialize power, energy, role="hero"
    @power = power
    @energy = energy
    @role = role
  end

  def attack other
    other.under_attack self
  end

  def under_attack by_who
    damage = caculated_damage_from(current_luck, by_who)
    @energy -= damage
  end

end
