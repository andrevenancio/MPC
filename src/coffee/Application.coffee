#import app.Visualizer
#import app.Audio
class Application
  @STAGE: {}
  constructor: ->
    @colors =
      drums: '#04BFB5'
      bass: '#037F79'
      guitar: '#05FFF2'
      effects: '#01403C'
      voice: '#05E5D9'

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
    colors.add(@visualizer, 'precision', 0, 1).step(0.01).name('motion blur')


  changeColor: (index, color) ->
    @visualizer.circles[index].color = color
    null


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
    null