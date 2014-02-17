class Sampler
  constructor: (context) ->
    @context = context
    @memory =
      files: []
      buffers: []
      sources: []

    @signals = {}
    @signals.progress = new signals.Signal()
    @signals.complete = new signals.Signal()

  #adds file to sampler
  add: (url) ->
    @memory.files.push url
    null

  #loads all files added to sampler, and fires callback on last file loaded
  load: ->
    for i in [0...@memory.files.length]
      @loadBuffer @memory.files[i]

  #loads a audio buffer via XMLHttpRequest2 api
  loadBuffer: (url) ->
    #Load buffer asynchronously
    request = new XMLHttpRequest()
    request.open "GET", url, true
    request.responseType = "arraybuffer"
    request.onload = =>
      #Asynchronously decode the audio file data in request.response
      @context.decodeAudioData request.response,
        (buffer) =>
          if !buffer
            console.error 'error decoding audio buffer for', url
            return
          @memory.buffers[url] = buffer

          #fires progress event
          @signals.progress.dispatch 'progress', { 'progress': Object.keys(@memory.buffers).length, 'total': @memory.files.length }

          #if the latest buffer was loaded, dispatch callback
          if Object.keys(@memory.buffers).length is @memory.files.length
            #fires complete event
            @signals.complete.dispatch 'complete', {}
          null
        , (error) ->
          console.error 'decode error', error
          return
      null
    request.send()
    null