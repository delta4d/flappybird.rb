require './lib/wall'

class Walls
  def initialize width, height
    @window_width = width
    @window_height = height
    @current = Wall.new width, height, width
    @next = Wall.new width, height, width*5/3
    @already = false
  end

  def reset
    @current = Wall.new @window_width, @window_height, @window_width
    @next = Wall.new @window_width, @window_height, @window_width*5/3
  end

  def contain? v
    @current.contain? v
  end

  def behind? x
    return false if @already
    return false if not @current.behind? x
    @already = true
  end

  def update state
    if state != 2
      @current.update
      @next.update
      if @current.gone?
        @already = false
        @current = @next
        @next = Wall.new @window_width, @window_height, @current.x+@window_width*2/3
      end
    end
  end

  def draw
    @current.draw
    @next.draw
  end
end
