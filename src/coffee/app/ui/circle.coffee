class Circle
  position:
    x: 0
    y: 0
  points: []
  constructor: (context, octaves = 40, radius = 60) ->
    @context = context
    @octaves = octaves
    @radius = radius
    @indexes = new Float32Array @octaves
    
  translate: (x, y) ->
    @position.x = x
    @position.y = y
    null

  feed: (index, value) ->
    @indexes[index] = value
    null

  draw: ->
    @getOctavesPosition()

    for i in [0...@points.length+1]

      ###
      if i <@points.length
        @context.beginPath(); 
        @context.arc(@points[i].x, @points[i].y, 1, 0, 2 * Math.PI, false);
        @context.fillStyle = 'cyan'
        @context.fill();
        @context.closePath()
      ###
      
      if i > 0
        prev = i-1
        cur = i%@octaves
        next = (i+1)%@octaves

        if i%2 is 0
          @context.beginPath();
          @context.moveTo(@points[prev].x, @points[prev].y);
          @context.quadraticCurveTo(@points[cur].x, @points[cur].y, @points[next].x, @points[next].y);
          @context.strokeStyle = 'cyan'
          @context.lineWidth = 1;
          @context.stroke()
          @context.closePath()

    null

  getOctavesPosition: ->
    @points = []
    for i in [0...@octaves]
      initialAngle = 90 * Math.PI/180
      angle = initialAngle + (i * Math.PI*2 / @octaves)
      x = @position.x + Math.cos(angle) * (@radius + @indexes[i])
      y = @position.y + Math.sin(angle) * (@radius + @indexes[i])

      @points.push { x: x, y: y }
    null