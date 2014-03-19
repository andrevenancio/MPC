#import app.ui.Circle
#import app.audio.Analizer
class Visualizer
  @WAIT: 'fa-spinner fa-spin'
  @STOP: 'fa-stop'
  @PLAY: 'fa-play'
  playing: false
  circles: []
  analyzers: []
  precision: 0.11
  background: [0,0,0]
  constructor: (mixer) ->
    @canvas = document.createElement 'canvas'
    @context = @canvas.getContext '2d'
    document.body.appendChild @canvas

    window.addEventListener 'resize', @resize, false
    #source for our audio analysis
    @mixer = mixer

    @init()

  init: ->
    for i in [0...5]
      @circles.push new Circle @context
      @analyzers.push new Analizer @mixer.channels[i].input

    @handleState Visualizer.WAIT
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

  toggleInfo: ->
    $('#info').toggleClass 'disable'
    if $('#info').hasClass 'disable'
      $('#more-info').hide()
    else
      $('#more-info').show().css { 'display': 'table'}
    null

  togglePlayback: (e) =>
    @playing = !@playing
    @handleState if @playing is true then Visualizer.PLAY else Visualizer.STOP
    null

  handleState: (state) ->
    if state is Visualizer.PLAY
      Application.STAGE.playback.dispatch 'stop'
    else if state is Visualizer.STOP
      Application.STAGE.playback.dispatch 'play'
    null

  render: =>
    alpha = if Circle.debug is true then 1 else @precision
    
    if alpha is 1
      @context.clearRect 0, 0, @width, @height
    else
      @context.beginPath()
      @context.fillStyle = 'rgba(' + Math.round(@background[0]) + ',' + Math.round(@background[1]) + ',' + Math.round(@background[2]) + ', ' + alpha + ')';
      @context.fillRect 0, 0, @width, @height
      @context.closePath()

    for i in [0...@circles.length]
      circle = @circles[i]
      value = @analyzers[i].octaves Circle.octaves
      #feed analizes into circle
      for j in [0...Circle.octaves]
        circle.feed j, value[j]

      circle.draw()
    requestAnimationFrame @render
    null
