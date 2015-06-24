class Bird
  BIRD_COUNT_BOUND = 21
  G = 9.8
  VY = Math.sqrt(2*G*40)

  attr_accessor :score

  def initialize width, height
    @font = Gosu::Font.new 30, name: './font/04B_19__.ttf'
    @birds = [*0..2].map{|i| Gosu::Image.new "./img/bird_#{i}.png"}
    @window_width = width
    @window_height = height
    @width = @birds.first.width
    @height = @birds.first.height
    @birth_x = width/5 + @width/2
    @birth_y = height/2 + @height/2
    @start_x = @birth_x
    @start_y = @birth_y
    @x = @birth_x
    @y = @birth_y
    @angle = 0
    @bird_count = 0
    @fly_time = 0
    @score = 0
    @vertices = [[(@width-2)/2, (@height-2)/2], [(@width-2)/2, -(@height-2)/2], 
                 [-(@width-2)/2, (@height-2)/2], [-(@width-2)/2, -(@height-2)/2]]
  end

  def reset
    @start_x = @birth_x
    @start_y = @birth_y
    @x = @birth_x
    @y = @birth_y
    @bird_count = 0
    @score = 0
    @angle = 0
  end

  def left
    @vertices.map{|v| (rot v).first}.min
  end

  def low
    @vertices.map{|v| (rot v).last}.max
  end

  def rot v
    x = v.first
    y = v.last
    [@x+x*Math.cos(@angle)-y*Math.sin(@angle), @y+x*Math.sin(@angle)+y*Math.cos(@angle)]
  end

  def hit? walls
    false
    @vertices.any?{|v| walls.contain? (rot v)}
  end

  def below? background
    low > background.ground_height
  end

  def fly t
    @fly_time += t * 9
    @y = @start_y - (VY*@fly_time - G*@fly_time*@fly_time/2)
    @angle = 90
    @angle = -Math.atan2(VY-G*@fly_time, 30)
    @angle += Math::PI * 2 if @angle < 0
  end

  def jump
    @fly_time = 0
    @start_x = @x
    @start_y = @y
  end

  def update state
    if state != 2
      @bird_count += 1
      @bird_count = 0 if @bird_count == BIRD_COUNT_BOUND
    end
  end

  def draw
    @birds[@bird_count*3/BIRD_COUNT_BOUND].draw_rot @x, @y, 1, @angle*180/Math::PI
    @font.draw @score, @window_width/2, @window_height/5, 2
  end
end
