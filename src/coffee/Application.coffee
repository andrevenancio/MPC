#import app.audio.sampler
#import app.audio.mixer8
#import app.audio.filter
class Application
  log: 'please wait...'
  sources: []
  isPlaying: false
  constructor: ->
    console.log 'MPC v.0.0.1'

    #sets global AudioContext
    @context = new webkitAudioContext()

    #adds a mixer with 8 channels
    @mixer = new Mixer8 @context

    #adds a low-pass filter to the master channel of the mixer
    @lowpass = new Filter @context, Filter.LOW_PASS, @mixer.master.input, @mixer.master.output
    @lowpass.toggle true

    #adds sampler
    @sampler = new Sampler @context
    @sampler.add 'mp3/Nude (Bass Stem).mp3'
    @sampler.add 'mp3/Nude (Drum Stem).mp3'
    @sampler.add 'mp3/Nude (Guitar Stem).mp3'
    @sampler.add 'mp3/Nude (String FX Stem).mp3'
    @sampler.add 'mp3/Nude (Voice Stem).mp3'    
    
    #TODO: dispatch events from the Sampler instead of the window
    window.addEventListener 'sampler-load-progress', @onSamplerLoadProgress, false
    window.addEventListener 'sampler-load-complete', @onSamplerLoadComplete, false    

    @init()

  init: ->
    #setup dat gui component
    @gui = new dat.GUI()
    @gui.add(@, 'log').listen()

    @folder_mixer = @gui.addFolder 'Mixer'
    @folder_mixer.add(@mixer.channels[0], 'volume', 0, 1).name('Bass').onChange((value)=>@mixer.channels[0].changeVolume(value))
    @folder_mixer.add(@mixer.channels[1], 'volume', 0, 1).name('Drums').onChange((value)=>@mixer.channels[1].changeVolume(value))
    @folder_mixer.add(@mixer.channels[2], 'volume', 0, 1).name('Guitar').onChange((value)=>@mixer.channels[2].changeVolume(value))
    @folder_mixer.add(@mixer.channels[3], 'volume', 0, 1).name('Effects').onChange((value)=>@mixer.channels[3].changeVolume(value))
    @folder_mixer.add(@mixer.channels[4], 'volume', 0, 1).name('Voice').onChange((value)=>@mixer.channels[4].changeVolume(value))
    
    @folder_master = @folder_mixer.addFolder 'Master'
    @filter_folder = @folder_master.addFolder 'Filter'

    test =
      q: 0
      frequency: 1
    @filter_folder.add(test, 'q', 0, 1).onChange((value)=>@lowpass.changeQuality(value))
    @filter_folder.add(test, 'frequency', 0, 1).onChange((value)=>@lowpass.changeFrequency(value))
    @folder_master.add(@mixer.master, 'volume', 0, 1).name('MASTER').onChange((value)=>@mixer.master.changeVolume(value))
    
    @gui.add(@, 'playAll').name('Play')
    @gui.add(@, 'stopAll').name('Stop')

    #starts loading the samples
    @sampler.load()

  onSamplerLoadProgress: (e) =>
    @log = 'Loading ' + e.detail.progress + '/' + e.detail.total
    null

  onSamplerLoadComplete: (e) =>
    @log = 'All samples Loaded'
    @folder_mixer.open()
    @folder_master.open()
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