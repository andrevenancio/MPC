#import app.audio.mixer8
#import app.audio.sampler
class Audio
  isPlaying: false
  sources: []
  
  constructor: ->
    #sets global AudioContext
    @context = new webkitAudioContext()

    #adds a mixer with 8 channels
    @mixer = new Mixer8 @context

    @info = document.getElementById 'info'

    #adds a sampler
    @sampler = new Sampler @context
    @sampler.signals.progress.add @onSamplerProgress
    @sampler.signals.complete.add @onSamplerComplete
    @sampler.add 'mp3/radiohead/Nude (Drum Stem).mp3'
    @sampler.add 'mp3/radiohead/Nude (Bass Stem).mp3'
    @sampler.add 'mp3/radiohead/Nude (Guitar Stem).mp3'
    @sampler.add 'mp3/radiohead/Nude (String FX Stem).mp3'
    @sampler.add 'mp3/radiohead/Nude (Voice Stem).mp3'
    @sampler.load()

  onSamplerProgress: (type, params) =>
    @info.innerHTML = 'Loading sound ' + params.progress + ' of ' + params.total
    null

  onSamplerComplete: (type, params) =>
    @info.innerHTML = '"Nude" is a song by the English rock band <strong>Radiohead</strong>, appearing as the third track on their 2007 album In Rainbows.<br/><br/>Visualization inspired by the Nike Moves App.'
    Application.STAGE.playback.dispatch 'ready'
    null

  playAll: ->
    return if @isPlaying is true
    @isPlaying = true
    for i in [0...@sampler.memory.files.length]
      #assigns instrument (buffer) to mixer input (gainNode)
      instrument = @sampler.memory.buffers[@sampler.memory.files[i]]
      input = @mixer.channels[i].input
      @playSound instrument, input
    null

  stopAll: ->
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