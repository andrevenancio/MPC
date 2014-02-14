class Analizer
  constructor: (input, fftSize = 2048) ->
    @input = input
    @fftSize = fftSize

    @output = @input.context.createAnalyser()
    @output.fftSize = @fftSize
    @input.connect @output

  analyze: ->
    freqByteData = new Uint8Array @output.frequencyBinCount
    @output.getByteFrequencyData freqByteData
    return freqByteData

  #gets average of all frequencies.
  average: ->
    data = @analyze()
    values = 0
    total = data.length
    for i in [0...total]
      values += data[i]
    
    return values / total

  #returns array of octave average
  octaves: (count) ->
    data = @analyze()

    octaves = []
    for i in [0...count]
      octaves.push (data[i] / 2)
    return octaves
