class Game

  def initialize engine, output
    @engine = engine
    @output = output
  end

  def start
    @engine.start
    @output.start_with_welcome
  end

end

