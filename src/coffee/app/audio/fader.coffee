class Fader
  constructor: (context, output) ->
    @context = context
    @volume = 1
    @input = @context.createGain()
    @output = output


    @input.connect @output

  changeVolume: (value) ->
    @volume = value
    #linear equation
    #@input.gain.value = value    

    #x-squared equation
    fraction = value / 1
    @input.gain.value = fraction * fraction
    null