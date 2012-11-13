module GameHelper

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
