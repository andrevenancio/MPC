#import app.audio.fader
class Mixer8
  channels: [] 
  constructor: (context) ->
    @context = context;
    
    @master = new Fader @context, @context.destination

    @channels[0] = new Fader @context, @master.input
    @channels[1] = new Fader @context, @master.input
    @channels[2] = new Fader @context, @master.input
    @channels[3] = new Fader @context, @master.input
    @channels[4] = new Fader @context, @master.input
    @channels[5] = new Fader @context, @master.input
    @channels[6] = new Fader @context, @master.input
    @channels[7] = new Fader @context, @master.input