#import app.math.mathutils
class Circle
  position:
    x: 0
    y: 0
  points: []
  constructor: (context, octaves = 20, radius = 0) ->
    @context = context
    @octaves = octaves
    @radius = radius
    @indexes = new Float32Array @octaves
    @color = '#'+Math.floor(Math.random()*16777215).toString(16)
    
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
    newPoints = MathUtils.calculateControlPoints @points, 0.25

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

    ### DEBUG POINTS ###
    ###
    for j in [0...newPoints.length]
      @context.beginPath()
      @context.arc(newPoints[j].x, newPoints[j].y, 1, 0, 2 * Math.PI, false)
      @context.fillStyle = 'green'
      @context.fill()
      @context.closePath()
    for i in [0...@points.length]
      @context.beginPath() 
      @context.arc(@points[i].x, @points[i].y, 1, 0, 2 * Math.PI, false)
      @context.fillStyle = 'cyan'
      @context.fill()
      @context.closePath()
    ###
    null

  getOctavesPosition: ->
    @points = []
    for i in [0...@octaves]
      angle = (i * Math.PI*2 / @octaves)
      x = @position.x + Math.cos(angle) * (@radius + @indexes[i])
      y = @position.y + Math.sin(angle) * (@radius + @indexes[i])

      @points.push 
        x: x
        y: y
    null