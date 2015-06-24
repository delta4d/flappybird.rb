class Background
  attr_reader :width, :height, :ground_height

  def initialize
    @font     = Gosu::Font.new 25, name: './font/04B_19__.ttf'
    @bg       = Gosu::Image.new './img/background.png'
    @ground   = Gosu::Image.new './img/ground.png'
    @width    = [@bg.width, @ground.width].min
    @height   = @bg.height + @ground.height
    @ground_height = @bg.height
    @ground_x = 0
    @ground_y = @bg.height
    @welcome  = true
    @dead = false
  end

  def reset
    @ground_x = 0
  end

  def update state
    @welcome, @dead = false, false if state != 0
    @dead = true if state == 2
    @ground_x -= 2
    @ground_x = 0 if @ground_x + @ground.width + 1 <= @width
  end

  def draw_welcome
    title = 'Flappy Bird in Ruby'
    help = 'Click to Jump'
    title_width = @font.text_width title
    help_width = @font.text_width help
    @font.draw title, (width-title_width)/2, height/10, 0
    @font.draw help, (width-help_width)/2, height*3/5, 0
  end

  def draw_dead
    msg = 'Ouch, You are dead'
    help = 'Click to Restart'
    msg_width = @font.text_width msg
    help_width = @font.text_width help
    @font.draw msg, (width-msg_width)/2, height*3/5, 2
    @font.draw help, (width-help_width)/2, height*3/5+50, 2
  end

  def draw
    @bg.draw 0, 0, 0
    @ground.draw @ground_x, @ground_y, 2
    draw_welcome if @welcome
    draw_dead if @dead
  end
end
