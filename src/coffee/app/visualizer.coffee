#import app.ui.circle
#import app.audio.analizer
class Visualizer
  circles: []
  analyzers: []
  constructor: (mixer) ->
    @canvas = document.createElement 'canvas'
    @context = @canvas.getContext '2d'
    document.body.appendChild @canvas

    window.addEventListener 'resize', @resize, false
    #source for our audio analysis
    @mixer = mixer

    @init()

  init: ->

    for i in [0...@mixer.channels.length]
      @circles.push new Circle @context
      @analyzers.push new Analizer @mixer.channels[i].input

    @resize()
    @render()
    null

  resize: (e) =>
    @width = window.innerWidth
    @height = window.innerHeight
    @canvas.width = @width
    @canvas.height = @height

    #always keeps circles at the center
    for i in [0...@circles.length]
      @circles[i].translate @width/2, @height/2
    null

  render: =>
    #cleans canvas
    #@context.clearRect 0, 0, @width, @height
    
    #motion blur effect
    @context.fillStyle = 'rgba(0,0,0,0.07)';
    @context.fillRect 0, 0, @width, @height

    for i in [0...@circles.length]
      circle = @circles[i]
      value = @analyzers[i].octaves circle.octaves
      #feed analizes into circle
      for j in [0...circle.octaves]
        circle.feed j, value[j]

      circle.draw()
    requestAnimationFrame @render
    null