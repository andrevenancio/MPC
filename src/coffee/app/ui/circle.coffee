#import app.math.mathutils
#import app.math.vec2
class Circle
  position: new Vec2()
  points: []
  @factor: 0.5
  @octaves: 6
  @debug: false
  constructor: (context, radius = 150, color = '#0FF') ->
    @context = context
    @radius = radius
    @indexes = new Float32Array 20
    @color = color
    
  translate: (x, y) ->
    @position.x = x
    @position.y = y
    null

  feed: (index, value) ->
    @indexes[index] = value
    null

  draw: ->
    @getOctavesPosition()

    #generate control points for quadratic bezier based on points
    newPoints = MathUtils.calculateControlPoints @points, Circle.factor

    #CUBIC BEZIER
    a = 0
    b = 0
    @context.beginPath()
    @context.strokeStyle = @color
    for i in [0...@points.length]
      a = i
      b = (i*2 + newPoints.length - 1) % newPoints.length
      c = i*2
      d = (i+1) % @points.length

      @context.moveTo @points[a].x, @points[a].y
      @context.bezierCurveTo newPoints[b].x, newPoints[b].y, newPoints[c].x, newPoints[c].y, @points[d].x, @points[d].y

    @context.lineWidth = 1
    @context.stroke()
    @context.closePath()

    if Circle.debug
      for j in [0...newPoints.length]
        @context.beginPath()
        @context.arc(newPoints[j].x, newPoints[j].y, 1, 0, 2 * Math.PI, false)
        @context.fillStyle = 'white'
        @context.fill()
        @context.closePath()
      for i in [0...@points.length]
        @context.beginPath() 
        @context.arc(@points[i].x, @points[i].y, 2, 0, 2 * Math.PI, false)
        @context.strokeStyle = 'white'
        @context.stroke()
        @context.closePath()

    null

  getOctavesPosition: ->
    @points = []
    for i in [0...Circle.octaves]
      angle = (i * Math.PI*2 / Circle.octaves)
      x = @position.x + Math.cos(angle) * (@radius + @indexes[i])
      y = @position.y + Math.sin(angle) * (@radius + @indexes[i])

      @points.push new Vec2 x, y
    null