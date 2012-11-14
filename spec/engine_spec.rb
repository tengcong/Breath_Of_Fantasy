require 'spec_helper'
describe Engine do
  describe "#initialize" do
    it "should create hero and several enimies" do
      Character.should_receive(:new).with(100, 200, 'hero')
      Character.should_receive(:new).at_least(1).times

      Engine.new
    end
  end

  describe "#over?" do
    context "1 v n" do
      context "enemy died" do
        it "game over" do
          en1 = double('enemy')
          en2 = double('enemy')
          en3 = double('enemy')

          Engine.any_instance.stub(:create_enemies).and_return([en1, en2, en3])
          engine = Engine.new(1)
          en1.stub(:died?).and_return(false)
          en2.stub(:died?).and_return(false)
          en3.stub(:died?).and_return(false)
          engine.over?.should == false

          en1.stub(:died?).and_return(true)
          en2.stub(:died?).and_return(false)
          en3.stub(:died?).and_return(false)
          engine.over?.should == false

          en1.stub(:died?).and_return(true)
          en2.stub(:died?).and_return(false)
          en3.stub(:died?).and_return(true)
          engine.over?.should == false

          en1.stub(:died?).and_return(true)
          en2.stub(:died?).and_return(true)
          en2.stub(:died?).and_return(true)
          engine.over?.should == true
        end
      end

      context "hero died" do
        it "game over" do
          hero = double('hero')

          Engine.any_instance.stub(:create_hero).and_return(hero)

          engine = Engine.new(1)
          hero.stub(:died?).and_return(false)
          engine.over?.should == false

          hero.stub(:died?).and_return(true)
          engine.over?.should == true
        end
      end
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
    context "1 v n" do
      it "should depend on Engine#next to fight in right order" do
        hero = Character.new(1,1)
        en1 = Character.new(1,1,'enemy')
        en2 = Character.new(1,1,'enemy')
        en3 = Character.new(1,1,'enemy')
        Engine.any_instance.stub(:create_enemies).and_return([en1, en2, en3])
        Engine.any_instance.stub(:create_hero).and_return(hero)

        engine = Engine.new(3)
        engine.stub(:next).and_return(en1, hero, en3, en2)

        en1.should_receive(:attack).ordered.and_call_original
        hero.should_receive(:under_attack).ordered

        hero.should_receive(:attack).ordered.and_call_original
        en1.should_receive(:under_attack).ordered

        hero.should_receive(:attack).ordered.and_call_original
        en2.should_receive(:under_attack).ordered

        hero.should_receive(:attack).ordered.and_call_original
        en3.should_receive(:under_attack).ordered

        en3.should_receive(:attack).ordered.and_call_original
        hero.should_receive(:under_attack).ordered

        en2.should_receive(:attack).ordered.and_call_original
        hero.should_receive(:under_attack).ordered

        engine.start_fight([1,0,3,2])
      end
    end
    context "1 v 1" do
      it "should depend on Engine#next to fight in right order" do
        hero = Character.new(1,1)
        enemy = Character.new(1,1,'enemy')
        Engine.any_instance.stub(:create_enemies).and_return([enemy])
        Engine.any_instance.stub(:create_hero).and_return(hero)

        engine = Engine.new(1)
        engine.stub(:next).and_return(enemy, hero)

        enemy.should_receive(:attack).ordered.and_call_original
        hero.should_receive(:under_attack).ordered
        hero.should_receive(:attack).ordered.and_call_original
        enemy.should_receive(:under_attack).ordered

        engine.start_fight([1,0])
      end
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
        Engine.new(3).start_fight([0,1,2,3])
      end
    end

    context "enemies attack hero" do
      it "should attack hero 3 times when 3 enemies" do
        @hero.should_receive(:under_attack).exactly(3).times
        Engine.new(3).start_fight([0,1,2,3])

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

      engine.next([1,3,2,0]).should == e1
      engine.next([1,3,2,0]).should == e3
      engine.next([1,3,2,0]).should == e2
      engine.next([1,3,2,0]).should == hero
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

          engine.next([0, 1, 2, 3]).should == hero
          engine.next([0, 1, 2, 3]).should == e1
          engine.next([0, 1, 2, 3]).should == e2
          engine.next([0, 1, 2, 3]).should == e3
          engine.next([0, 1, 2, 3]).should == hero
          engine.next([0, 1, 2, 3]).should == e1
          engine.next([0, 1, 2, 3]).should == e2
          engine.next([0, 1, 2, 3]).should == e3
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
          engine.next([0, 1]).should == hero
          engine.next([0, 1]).should == enemy
          engine.next([0, 1]).should == hero
          engine.next([0, 1]).should == enemy
        end
      end
    end
  end
end
