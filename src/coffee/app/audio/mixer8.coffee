class Mixer8
  constructor: (context) ->
    @context = context;
    
    @master = new Fader @context, @context.destination

    @channels = []
    @channels[0] = new Fader @context, @master.input
    @channels[1] = new Fader @context, @master.input
    @channels[2] = new Fader @context, @master.input
    @channels[3] = new Fader @context, @master.input
    @channels[4] = new Fader @context, @master.input
    @channels[5] = new Fader @context, @master.input
    @channels[6] = new Fader @context, @master.input
    @channels[7] = new Fader @context, @master.input
  
class Fader
  constructor: (context, output) ->
    @context = context
    @volume = 1

    @input = @context.createGain()
    @input.connect output

  changeVolume: (value) ->
    #linear equation
    #@input.gain.value = value    

    #x-squared equation
    fraction = value / 1
    @input.gain.value = fraction * fraction
    null