#import app.ui.Circle
#import app.audio.Analizer
class Visualizer
  @WAIT: 'fa-spinner fa-spin'
  @STOP: 'fa-stop'
  @PLAY: 'fa-play'
  playing: false
  circles: []
  analyzers: []
  precision: 0.03
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

  enableControls: ->
    #pads
    $('#loop-A').bind 'click touchstart', @handleClickTouch
    $('#loop-S').bind 'click touchstart', @handleClickTouch
    $('#loop-D').bind 'click touchstart', @handleClickTouch
    $('#loop-F').bind 'click touchstart', @handleClickTouch
    $('#loop-G').bind 'click touchstart', @handleClickTouch

    #controls
    $('#info').bind 'click touchstart', @toggleInfo
    $('#playback').bind 'click touchstart', @togglePlayback

    window.addEventListener 'keydown', @handleKeyDown
    null

  handleKeyDown: (e) =>
    #console.log e.keyCode
    switch e.keyCode
      when 65 then @handleKey 'A'
      when 83 then @handleKey 'S'
      when 68 then @handleKey 'D'
      when 70 then @handleKey 'F'
      when 71 then @handleKey 'G'
      when 32 then @togglePlayback()
    null

  handleClickTouch: (e) =>
    @handleKey $(e.currentTarget)[0].id.split('-')[1]
    null

  handleKey: (key) =>
    target = $('#loop-' + key)

    #maps letters to mixing channels
    maps = []
    maps['A'] = 0
    maps['S'] = 1
    maps['D'] = 2
    maps['F'] = 3
    maps['G'] = 4

    #toggle state
    target.toggleClass 'enable'

    if target.hasClass 'enable'
      Application.STAGE.mixer.dispatch maps[key], 1
    else
      Application.STAGE.mixer.dispatch maps[key], 0
    null

  toggleInfo: (e) =>
    $('#info').toggleClass 'enable'

    if $('#info').hasClass 'enable'
      $('#more-info').show().css { 'display': 'table'}
    else
      $('#more-info').hide()

    null

  togglePlayback: (e) =>
    @playing = !@playing
    @handleState if @playing is true then Visualizer.PLAY else Visualizer.STOP
    null

  handleState: (state) ->
    $('#playback span i').removeClass Visualizer.WAIT
    $('#playback span i').removeClass Visualizer.STOP
    $('#playback span i').removeClass Visualizer.PLAY

    $('#playback span i').addClass state

    if state is Visualizer.PLAY
      Application.STAGE.playback.dispatch 'stop'
    else if state is Visualizer.STOP
      Application.STAGE.playback.dispatch 'play'
    null


  render: =>
    #cleans canvas
    #@context.clearRect 0, 0, @width, @height

    #console.log('rgba(' + Math.round(@background[0]) + ',' + Math.round(@background[1]) + ',' + Math.round(@background[2]) + ', ' + @precision + ')');
    #motion blur effect
    @context.beginPath()
    @context.fillStyle = 'rgba(' + Math.round(@background[0]) + ',' + Math.round(@background[1]) + ',' + Math.round(@background[2]) + ', ' + @precision + ')';
    @context.fillRect 0, 0, @width, @height
    @context.closePath()

    for i in [0...@circles.length]
      circle = @circles[i]
      value = @analyzers[i].octaves circle.octaves
      #feed analizes into circle
      for j in [0...circle.octaves]
        circle.feed j, value[j]

      circle.draw()
    requestAnimationFrame @render
    null
