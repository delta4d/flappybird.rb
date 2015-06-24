require 'gosu'
require './lib/bird'
require './lib/walls'
require './lib/background'

class FlappyBird < Gosu::Window
  def initialize
    @background = Background.new
    super @background.width, @background.height, false
    self.caption = 'Flappy Bird in Ruby'

    @bird = Bird.new width, height
    @walls = Walls.new width, height
    @state = 0
    @objs = [@background, @bird]
    @ago = Gosu::milliseconds / 1000.0
    @state2_time = 0
  end

  def needs_cursor?
    true
  end

  def reset
    @state = 0
    @bird.reset
    @walls.reset
    @background.reset
    @objs.pop
    @state2_time = 0
  end

  def update
    now = Gosu::milliseconds / 1000.0
    t = now - @ago
    @ago = now
    case @state
    when 0
      if button_down? Gosu::MsLeft
        @state = 1
        @bird.jump
        @objs << @walls
      end
    when 1
      @bird.jump if button_down? Gosu::MsLeft
      @bird.fly t
      @bird.score += 1 if @walls.behind? @bird.left
      @state = 2 if @bird.hit? @walls or @bird.below? @background
    when 2
      @state2_time += t
      reset if button_down? Gosu::MsLeft and @state2_time > 1
    else
      'something terrible happened...'
    end
    @objs.each{|obj| obj.update @state}
  end

  def draw
    @objs.each{|obj| obj.draw}
  end
end

FlappyBird.new.show
