require "engine"
describe Engine do

  let(:tim) { double("tim") }
  let(:tom) { double("tom") }
  let(:engine){ Engine.new tim, tom }

  before(:each) do
    tim.stub(:energy => 60, :power => 45)
    tom.stub(:energy => 60, :power => 45)
  end

  describe "#set_position" do
    it "should assign tom and tim in a arr" do
      arr = engine.set_position
      arr[0].should == tim
      arr[1].should == tom
    end
  end

  describe "#get_first_index" do
    it "sholud return 1 | 0 by turns" do
      engine.get_first_index.should == 0
      engine.get_first_index.should == 1
      engine.get_first_index.should == 2
    end
  end

  describe "#start_fight" do
    before(:each) do
      tim.stub(:attack) do
        tom.stub(:energy => 0)
      end
    end
    it "should end till one died" do
      engine.start_fight
      tom.energy.should == 0
    end
  end

end
