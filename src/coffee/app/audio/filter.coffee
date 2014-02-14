#http://www.w3.org/TR/webaudio/#BiquadFilterNode-section
class Filter
  @LOW_PASS: 0
  @HIGH_PASS: 1
  @BAND_PASS: 2
  @LOW_SHELF: 3
  @HIGH_SHELF: 4
  @PEAKING: 5
  @NOTCH: 6
  @ALL_PASS: 7

  @QUAL_MUL: 30

  constructor: (context, type = Filter.LOW_PASS, input, output) ->
    @context = context
    @type = type
    @input = input
    @output = output

    @frequency = 0
    @Q = 0

    @filter = @context.createBiquadFilter()
    @filter.type = @type
    @filter.frequency.value = 5000
    #Connect source to filter, filter to destination.
    @input.connect @filter
    @filter.connect @output

  #enables disables filter. boolean
  toggle: (enable) ->
    @input.disconnect 0
    @filter.disconnect 0

    if enable
      #Connect through the filter.
      @input.connect @filter
      @filter.connect @output
    else
      #Otherwise, connect directly.
      @input.connect @output
    null

  #changes quality curve of filter. Number 0-1
  changeQuality: (value) ->
    @Q = value * Filter.QUAL_MUL
    @filter.Q.value = @Q
    null


  changeFrequency: (value) ->
    #Clamp the frequency between the minimum value (40 Hz) and half of the sampling rate.
    minValue = 40
    maxValue = @context.sampleRate / 2
    #Logarithm (base 2) to compute how many octaves fall in the range.
    numberOfOctaves = Math.log(maxValue / minValue) / Math.LN2
    #Compute a multiplier from 0 to 1 based on an exponential scale.
    multiplier = Math.pow(2, numberOfOctaves * (value - 1.0))
    #Get back to the frequency value between min and max.
    @frequency = maxValue * multiplier
    @filter.frequency.value = @frequency
    null