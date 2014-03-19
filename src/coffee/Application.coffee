#import app.Visualizer
#import app.Audio
class Application

  @STAGE: {}

  constructor: ->
    @settings =
      info: true
      debug: false
      drums:
        color: '#ff0000'
        volume: 1
      bass:
        color: '#6d89e3'
        volume: 1
      guitar:
        color: '#a2e368'
        volume: 1
      effects:
        color: '#00afa3'
        volume: 1
      voice: 
        color: '#ffffff'
        volume: 1
    
    Application.STAGE.playback = new signals.Signal()
    Application.STAGE.playback.add @onPlayback

    @audio = new Audio()
    @visualizer = new Visualizer @audio.mixer, @settings.colors

    @gui = new dat.GUI()
    @gui.add(@settings, 'info').onChange((value) => @visualizer.toggleInfo())
    @gui.add(@settings, 'debug').onChange((value) => Circle.debug = value)
    @gui.add Circle, 'factor', -1, 1
    @gui.add(Circle, 'octaves', 3, 20).step(1)
    @gui.add(@visualizer, 'precision', 0, 1).step(0.01).name('blur')
    @gui.addColor @visualizer, 'background'
    
    folder = @gui.addFolder 'Instruments'
    drums = folder.addFolder 'Drums'
    drums.addColor(@settings.drums, 'color').onChange((value) => @changeColor 0, value)
    drums.add(@settings.drums, 'volume', 0, 1).onChange((value) => @audio.mixer.channels[0].changeVolume value)
    bass = folder.addFolder 'Bass'
    bass.addColor(@settings.bass, 'color').onChange((value) => @changeColor 1, value)
    bass.add(@settings.bass, 'volume', 0, 1).onChange((value) => @audio.mixer.channels[1].changeVolume value)
    gtr = folder.addFolder 'Guitar'
    gtr.addColor(@settings.guitar, 'color').onChange((value) => @changeColor 2, value)
    gtr.add(@settings.guitar, 'volume', 0, 1).onChange((value) => @audio.mixer.channels[2].changeVolume value)
    fx = folder.addFolder 'Effects'
    fx.addColor(@settings.effects, 'color').onChange((value) => @changeColor 3, value)
    fx.add(@settings.effects, 'volume', 0, 1).onChange((value) => @audio.mixer.channels[3].changeVolume value)
    voice = folder.addFolder 'Voice'
    voice.addColor(@settings.voice, 'color').onChange((value) => @changeColor 4, value)
    voice.add(@settings.voice, 'volume', 0, 1).onChange((value) => @audio.mixer.channels[4].changeVolume value)


    for i in [0...5]
      color = @transformIndexIntoColor i
      @changeColor i, color

  changeColor: (index, color) ->
    #change circle colors
    @visualizer.circles[index].color = color
    null

  transformIndexIntoColor: (index) ->
    color = ''
    switch index
      when 0 then color = @settings.drums.color
      when 1 then color = @settings.bass.color
      when 2 then color = @settings.guitar.color
      when 3 then color = @settings.effects.color
      when 4 then color = @settings.voice.color
    return color

  onPlayback: (value) =>
    switch value
      when 'ready'
        @visualizer.handleState Visualizer.STOP
        @gui.add(@audio, 'playAll').name('Play')
        @gui.add(@audio, 'stopAll').name('Stop')
      when 'play' then @audio.playAll()
      when 'stop' then @audio.stopAll()
    null
