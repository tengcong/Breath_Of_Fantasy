require 'game'

describe Game do

  let(:engine) { double('engine') }
  let(:output) { double('output') }

  let(:game){ Game.new engine, output }

  describe "#start" do
    it "should initialize engine" do
      engine.should_receive(:start)
      output.should_receive(:start_with_welcome)
      game.start
    end
  end

end
