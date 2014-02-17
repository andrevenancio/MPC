#import app.visualizer
#import app.audio
class Application
  @STAGE: {}
  constructor: ->
    Application.STAGE.playback = new signals.Signal()
    Application.STAGE.playback.add @onPlayback

    Application.STAGE.mixer = new signals.Signal()
    Application.STAGE.mixer.add @onMixer

    @visualizer = new Visualizer()
    @audio = new Audio()

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


