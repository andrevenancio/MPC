class Visualizer
  playing: false
  @WAIT: 'fa-spinner fa-spin'
  @STOP: 'fa-stop'
  @PLAY: 'fa-play'
  constructor: () ->
    @handleState Visualizer.WAIT

  enableControls: ->
    #pads
    $('#pad-A').bind 'click touchstart', @handleClickTouch
    $('#pad-S').bind 'click touchstart', @handleClickTouch
    $('#pad-D').bind 'click touchstart', @handleClickTouch
    $('#pad-F').bind 'click touchstart', @handleClickTouch
    $('#pad-G').bind 'click touchstart', @handleClickTouch

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
    @handleKey $(e.currentTarget).find('span').text()
    null

  handleKey: (key) =>
    target = $('#pad-' + key)

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

    if state is Visualizer.STOP
      Application.STAGE.playback.dispatch 'stop'
    else if state is Visualizer.PLAY
      Application.STAGE.playback.dispatch 'play'
    null
