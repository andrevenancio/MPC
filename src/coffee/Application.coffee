#import app.audio.sampler
#import app.audio.mixer8
class Application
  loadedSamples: ''
  sources: []
  isPlaying: false
  constructor: ->
    console.log 'MPC v.0.0.1'

    #sets global AudioContext
    @context = new webkitAudioContext()

    #adds a mixer with 8 channels
    @mixer = new Mixer8 @context

    #adds sampler
    @sampler = new Sampler @context
    @sampler.add 'wav/Nude (Bass Stem).wav'
    @sampler.add 'wav/Nude (Drum Stem).wav'
    @sampler.add 'wav/Nude (Guitar Stem).wav'
    @sampler.add 'wav/Nude (String FX Stem).wav'
    @sampler.add 'wav/Nude (Voice Stem).wav'    
    
    #TODO: dispatch events from the Sampler instead of the window
    window.addEventListener 'sampler-load-progress', @onSamplerLoadProgress, false
    window.addEventListener 'sampler-load-complete', @onSamplerLoadComplete, false    

    #adds dat.GUI()
    @gui = new dat.GUI();
    @progressbar = @gui.add(@, 'loadedSamples').listen()

    #starts loading the samples
    @sampler.load()

  onSamplerLoadProgress: (e) =>
    @loadedSamples = 'Loading ' + e.detail.progress + '/' + e.detail.total
    null

  onSamplerLoadComplete: (e) =>
    @gui.remove @progressbar
   
    mixer = @gui.addFolder 'Mixer'
    mixer.add(@mixer.channels[0], 'volume', 0, 1).name('Bass').onChange((value)=>@mixer.channels[0].changeVolume(value))
    mixer.add(@mixer.channels[1], 'volume', 0, 1).name('Drums').onChange((value)=>@mixer.channels[1].changeVolume(value))
    mixer.add(@mixer.channels[2], 'volume', 0, 1).name('Guitar').onChange((value)=>@mixer.channels[2].changeVolume(value))
    mixer.add(@mixer.channels[3], 'volume', 0, 1).name('Effects').onChange((value)=>@mixer.channels[3].changeVolume(value))
    mixer.add(@mixer.channels[4], 'volume', 0, 1).name('Voice').onChange((value)=>@mixer.channels[4].changeVolume(value))
    master = mixer.addFolder 'Master'
    master.open()
    master.add(@mixer.master, 'volume', 0, 1).name('MASTER').onChange((value)=>@mixer.master.changeVolume(value))

    @gui.add(@, 'playAll').name('Play sounds')
    @gui.add(@, 'stopAll').name('Stop sounds')
    null

  playAll: =>
    return if @isPlaying is true
    @isPlaying = true
    for i in [0...@sampler.memory.files.length]
      #assigns instrument (buffer) to mixer input (gainNode)
      instrument = @sampler.memory.buffers[@sampler.memory.files[i]]
      input = @mixer.channels[i].input
      @playSound instrument, input
    null

  stopAll: =>
    return if @isPlaying is false
    @isPlaying = false
    for i in [0...@sources.length]
      source = @sources[i]
      if !source.stop
        source.stop = source.noteOff
      source.stop 0
    @sources = []
    null

  playSound: (buffer, input, time_ = 0, loop_ = false) ->
    #creates a sound source
    source = @context.createBufferSource()
    #tell the source which sound to play
    source.buffer = buffer
    #connect the source to mix channel
    source.connect input
    #loop or not
    source.loop = loop_
    #play the source now
    if !source.start
      source.start = source.noteOn
    source.start time_
    @sources.push source
    null





