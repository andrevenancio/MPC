#import app.Visualizer
#import app.Audio
class Application
  @STAGE: {}
  constructor: ->
    @colors =
      drums: '#ff0000'
      bass: '#6d89e3'
      guitar: '#a2e368'
      effects: '#00afa3'
      voice: '#ffffff'

    Application.STAGE.playback = new signals.Signal()
    Application.STAGE.playback.add @onPlayback

    Application.STAGE.mixer = new signals.Signal()
    Application.STAGE.mixer.add @onMixer

    @audio = new Audio()
    @visualizer = new Visualizer @audio.mixer, @colors

    gui = new dat.GUI()
    colors = gui.addFolder 'Colors'
    colors.open()
    colors.addColor(@colors, 'drums').onChange((value)=> @changeColor 0, value)
    colors.addColor(@colors, 'bass').onChange((value)=>@changeColor 1, value)
    colors.addColor(@colors, 'guitar').onChange((value)=>@changeColor 2, value)
    colors.addColor(@colors, 'effects').onChange((value)=>@changeColor 3, value)
    colors.addColor(@colors, 'voice').onChange((value)=>@changeColor 4, value)
    colors.addColor @visualizer, 'background'
    colors.add(@visualizer, 'precision', 0, 1).step(0.01).name('motion blur')

    for i in [0...5]
      color = @transformIndexIntoColor i
      @changeColor i, color


  changeColor: (index, color) ->
    #change circle colors
    @visualizer.circles[index].color = color
    #change button colors

    id = @transformIndexIntoId index

    $(id).css {
      'border': '1px solid ' + color,
      'box-shadow': '0px 0px 14px ' + color,
      'color': color
    }
    null

  transformIndexIntoColor: (index) ->
    color = ''
    switch index
      when 0 then color = @colors.drums
      when 1 then color = @colors.bass
      when 2 then color = @colors.guitar
      when 3 then color = @colors.effects
      when 4 then color = @colors.voice
    return color

  transformIndexIntoId: (index) ->
    id = ''
    switch index
      when 0 then id = '#loop-A'
      when 1 then id = '#loop-S'
      when 2 then id = '#loop-D'
      when 3 then id = '#loop-F'
      when 4 then id = '#loop-G'
    return id

  #handles Audio playback (READY/PLAY/STOP)
  onPlayback: (value) =>
    switch value
      when 'ready'
        #all samples have loaded.
        @visualizer.enableControls()
        @visualizer.handleState Visualizer.STOP
      when 'play' then @audio.playAll()
      when 'stop' then @audio.stopAll()
    null

  #on mute/unmute track
  onMixer: (track, value) =>
    @audio.mixer.channels[track].changeVolume value

    id = @transformIndexIntoId track
    color = @transformIndexIntoColor track
    target = $(id)
    if not target.hasClass 'enable'
      target.css {
        'border': '1px solid #666',
        'box-shadow': 'none'
      }
    else
      target.css {
        'border': '1px solid ' + color,
        'box-shadow': '0px 0px 14px ' + color
      }
    null
