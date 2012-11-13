require 'spec_helper'
describe Engine do
  describe "#initialize" do
    it "should create hero and several enimies" do
      Character.should_receive(:new).with(200, 200, 'hero')
      Character.should_receive(:new).with(50, 50, 'enemy').at_least(1).times

      Engine.new
    end
  end

  describe "#next" do
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
          engine.next.should == hero
          engine.next.should == enemy
          engine.next.should == hero
          engine.next.should == enemy
        end
      end
    end
  end
end
