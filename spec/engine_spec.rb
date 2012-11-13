require 'spec_helper'
describe Engine do
  describe "#initialize" do
    it "should create hero and several enimies" do
      Character.should_receive(:new).with(200, 200, 'hero')
      Character.should_receive(:new).at_least(1).times

      Engine.new
    end
  end

  describe "#create_fight_order" do
    it "should return arr with rand right figure " do
      engine = Engine.new(3)
      engine.create_fight_order.should be_include(3)
      engine.create_fight_order.should be_include(1)
      engine.create_fight_order.should be_include(2)
      engine.create_fight_order.should be_include(0)
      engine.create_fight_order.should_not be_include(4)
    end
  end

  describe "#start_fight" do
    before(:each) do
      @hero = Character.new(1,1)

      Engine.any_instance.stub(:create_hero).and_return(@hero)
      Engine.any_instance.stub(:create_enemies) do
        [].tap{ |res| 3.times{ res << Character.new(1,1,"enemy") } }
      end
    end
    context "hero attack enimies" do
      it "should attack every enemy" do
        @hero.should_receive(:attack).exactly(3).times
        Engine.new(3).start_fight
      end
    end

    context "enemies attack hero" do
      it "should attack hero 3 times when 3 enemies" do
        @hero.should_receive(:under_attack).exactly(3).times
        Engine.new(3).start_fight
      end
    end
  end

  describe "#next" do
    it "return right order by create_fight_order" do
      hero = double("hero")
      e1 = double('e1')
      e2 = double('e2')
      e3 = double('e3')

      Engine.any_instance.stub(:create_hero).and_return(hero)
      Engine.any_instance.stub(:create_enemies).and_return([e1, e2, e3])

      engine = Engine.new(3)
      engine.stub(:create_fight_order).and_return([1,3,2,0])

      engine.next.should == e1
      engine.next.should == e3
      engine.next.should == e2
      engine.next.should == hero
    end
    context "1 hero and several enemies" do
      context "hero first" do
        it "should caculate right orders" do
          hero = double('hero')
          e1 = double('e1')
          e2 = double('e2')
          e3 = double('e3')

          # this a trick to stub before new
          Engine.any_instance.stub(:create_hero).and_return(hero)
          Engine.any_instance.stub(:create_enemies).and_return([e1, e2, e3])

          engine = Engine.new(2)
          engine.stub(:create_fight_order).and_return([0, 1, 2, 3])

          engine.next.should == hero
          engine.next.should == e1
          engine.next.should == e2
          engine.next.should == e3
          engine.next.should == hero
          engine.next.should == e1
          engine.next.should == e2
          engine.next.should == e3
        end
      end
    end
    context "1 hero and 1 enemy" do
      context "hero first" do
        it "should caculate right orders" do
          hero, enemy = double('hero'), double('enemy')
          Character.stub(:new) do |*args|
            if args.include?("hero")
              hero
            elsif args.include?("enemy")
              enemy
            end
          end

          engine = Engine.new(1)
          engine.stub(:create_fight_order).and_return([0, 1])
          engine.next.should == hero
          engine.next.should == enemy
          engine.next.should == hero
          engine.next.should == enemy
        end
      end
    end
  end
end
