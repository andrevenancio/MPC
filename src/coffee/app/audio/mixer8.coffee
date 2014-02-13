class Mixer8
  constructor: (context) ->
    @context = context;
    
    @channel1 = @context.createGain()
    @channel2 = @context.createGain()
    @channel3 = @context.createGain()
    @channel4 = @context.createGain()
    @channel5 = @context.createGain()
    @channel6 = @context.createGain()
    @channel7 = @context.createGain()
    @channel8 = @context.createGain()

    ###
    // Create a gain node.
    var gainNode = context.createGain();
    // Connect the source to the gain node.
    source.connect(gainNode);
    // Connect the gain node to the destination.
    gainNode.connect(context.destination);
    ###