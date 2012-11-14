require 'spec_helper'
describe Character do


  describe "died?" do
    it "depends on character's energy" do
      c = Character.new 1, 1
      c.died?.should == false
      c.energy = 0
      c.died?.should == true
    end
  end

  describe "#initialize" do
    it "should be initialized with power and energy" do
      c = Character.new 100, 10
      c.power.should == 100
      c.energy.should == 10
    end

    it "assign role to self with params" do
      c = Character.new 100, 100, "hero"
      c.role.should == "hero"
    end
  end

  describe "#attack" do

    let(:hero){ Character.new 200, 200, "hero"}
    let(:enemy) {Character.new 10, 20, "enemy"}

    context "hero attack enemy" do
      it "should make enemy under attack" do
        enemy.should_receive(:under_attack)
        hero.attack enemy
      end
    end

    context "enemy attack hero" do
      it "should make hero under attack" do
        hero.should_receive(:under_attack)
        enemy.attack hero
      end
    end
  end

  describe "#under_attack" do
    let(:hero){ Character.new 60, 60, "hero"}
    let(:enemy){ Character.new 45, 60, "enemy"}

    def get_shuffle_value_of range
      range.to_a.shuffle.first
    end
    before(:each) do
      hero.attack enemy
    end

    context "luck is 0-3" do
      it "should miss" do
        luck = get_shuffle_value_of(0..3)
        enemy.stub(:current_luck).and_return(luck)
        expect{ hero.attack enemy }.to_not change{enemy.energy}
      end
    end

    context "luck is 4-70" do
      it "should cause 1/3 of hero power points" do
        luck = get_shuffle_value_of(4..70)
        enemy.stub(:current_luck).and_return(luck)
        expect{ hero.attack enemy }.to change{enemy.energy}.by(-hero.power/3)
      end
    end

    context "luck is 71-96" do
      it "should cause 1/3 of hero power plus 20% of this damage" do
        luck = get_shuffle_value_of(71..96)
        enemy.stub(:current_luck).and_return(luck)
        expect{ hero.attack enemy }.to change{enemy.energy}.by(-(hero.power/3 + hero.power/3 * 0.2))
      end
    end

    context "luck is 97-100" do
      it "should cause double of normal attack" do
        luck = get_shuffle_value_of(97..100)
        enemy.stub(:current_luck).and_return(luck)
        expect{ hero.attack enemy }.to change{enemy.energy}.by(-(hero.power * 2))
      end
    end
  end

end
