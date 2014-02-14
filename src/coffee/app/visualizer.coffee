#import app.ui.circle
#import app.audio.analizer
class Visualizer

  constructor: (mixer) ->
    @canvas = document.createElement 'canvas'
    @context = @canvas.getContext '2d'
    document.body.appendChild @canvas

    window.addEventListener 'resize', @resize, false
    #source for our audio analysis
    @mixer = mixer

    @init()

  init: ->
    #created a circle
    @circle = new Circle @context

    #creates an analyzer
    #TODO: move this to a lovely class in the Audio folder
    @analyzer = new Analizer @mixer.master.input

    @resize()
    @render()
    null

  resize: (e) =>
    @width = window.innerWidth
    @height = window.innerHeight
    @canvas.width = @width
    @canvas.height = @height

    #always keeps circle at the center
    @circle.translate @width/2, @height/2
    null

  render: =>
    #cleans canvas
    @context.clearRect 0, 0, @width, @height

    #analyses audio and normalize average
    #max radius is 100px
    #value = 200 * @analyzer.average() / 255


    value = @analyzer.octaves @circle.octaves
    #feed analizes into circle
    for i in [0...@circle.octaves]
      @circle.feed i, value[i]

    #draws circle
    @circle.draw()
    requestAnimationFrame @render
    null