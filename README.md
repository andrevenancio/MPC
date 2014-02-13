# MPC prototype
WebAudio API MPC prototype


Sampler
---
A sampler loads and stores WAV files in buffers so they can be attached to context. It dispatches loading progress, and loading complete events to the window

Available methods:

1. add(url)
2. load()


Mixer16
---
16 Track Mixer. Handles volume

##Running local version

### Install all dependencies in your package.json
```shell
npm install 
```

### Run local Gruntfile
```shell
grunt
```
