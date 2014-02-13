#import app.audio.sampler
class Application
  constructor: ->
    @gui = new dat.GUI();

    #sets global AudioContext
    @context = new webkitAudioContext()

    #sets sampler (handles all external files converting them to audio buffers)
    @sampler = new Sampler(@context, )
