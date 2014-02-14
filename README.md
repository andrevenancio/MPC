# MPC prototype
WebAudio API MPC prototype

[![Example](http://andrevenancio.github.com/MPC/deploy/preview.png)](http://andrevenancio.github.com/MPC/deploy/index.html)

Sampler
---
A sampler loads and stores WAV files in buffers so they can be attached to context. It dispatches loading progress, and loading complete events to the window


Mixer8
---
8 Track Mixer. Handles volumes!

Analyzer
---
sound analyzer. analyzes using `octaves` or global `average`




##Running local version
* Install all dependencies in your package.json
```shell
npm install 
```
* Run local Gruntfile
```shell
grunt
```