class Vec2

  @magnitude: (vector) ->
    return Math.sqrt vector.x*vector.x + vector.y*vector.y

  @magnitudeSq: (vector) ->
    return (vector.x*vector.x + vector.y*vector.y)

  constructor: (@x = 0, @y = 0) ->

  normalize: ->
    len = Vec2.magnitude @
    if len > 0.00001
      @x = @x / len
      @y = @y / len
    else
      @x = 0
      @y = 0
    return @

  subtract: (vector) ->
    @x -= vector.x
    @y -= vector.y
    return @

  add: (vector) ->
    @x += vector.x
    @y += vector.y
    return @

  multiply: (v) ->
    if v instanceof Vec2
      @x *= v.x
      @y *= v.y
    else
      @x *= v
      @y *= v
    return @

  divide: (v) ->
    if v instanceof Vec2
      @x /= v.x
      @y /= v.y
    else
      @x /= v
      @y /= v
    return @

  limit: (max) ->
    mag = Vec2.magnitudeSq(@)

    if mag > max*max
      @normalize()
      @multiply max
    return @
