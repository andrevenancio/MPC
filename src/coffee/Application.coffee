#import app.audio.sampler
#import app.audio.mixer8
class Application
  loadedSamples: ''
  constructor: ->
    #adds gui component
    @gui = new dat.GUI();
    @progressbar = @gui.add(@, 'loadedSamples').listen()

    #sets global AudioContext
    @context = new webkitAudioContext()

    #adds a mixer with 8 channels
    @mixer = new Mixer8 @context

    #TODO: dispatch events from the Sampler instead of the window
    window.addEventListener 'sampler-load-progress', @onSamplerLoadProgress, false
    window.addEventListener 'sampler-load-complete', @onSamplerLoadComplete, false

    #sets sampler (handles all external files converting them to audio buffers)
    @sampler = new Sampler @context
    @sampler.add 'wav/Nude (Bass Stem).wav'
    @sampler.add 'wav/Nude (Drum Stem).wav'
    @sampler.add 'wav/Nude (Guitar Stem).wav'
    @sampler.add 'wav/Nude (String FX Stem).wav'
    @sampler.add 'wav/Nude (Voice Stem).wav'    
    @sampler.load()

  onSamplerLoadProgress: (e) =>
    @loadedSamples = 'Loading ' + e.detail.progress + '/' + e.detail.total
    null

  onSamplerLoadComplete: (e) =>
    @gui.remove @progressbar
    @gui.add @, 'playAll'
    null

  playAll: =>
    console.log 'play all sounds'
    for i in [0...@sampler.memory.files.length]
      @playSound @sampler.memory.buffers[@sampler.memory.files[i]]
    null



  playSound: (buffer, time) ->
    #creates a sound source
    source = @context.createBufferSource()
    #tell the source which sound to play
    source.buffer = buffer
    #connect the source to the context's destination (the speakers)
    source.connect @context.destination
    #play the source now
    source.start time
    null