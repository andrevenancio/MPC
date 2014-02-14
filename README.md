#MPC prototype
WebAudio API MPC prototype

#### Examples
[![Example](http://andrevenancio.github.com/MPC/deploy/preview.png)](http://andrevenancio.github.com/MPC/deploy/index.html)

## Sampler
A sampler loads and stores external audio files in buffers so they can be attached to a audio context. It dispatches progress and complete loading events.

#### public methods
* `add(url)` adds a file url to the sampler.
* `load()` loads all files in the sampler.


## Mixer8
An Mixer8. Combines 8 signals into a stereo output.


## Analyzer
An Analyzer analyzes using sound buffers. Can be attached to any buffer (this includes the master and the individual faders in the `Mixer8`).

#### public methods
* `average()` returns the average value of the buffer.
* `octaves(count)` returns an array of averages by octave.

## Filter
A Filter can added to any sound buffer. There are several kinds of filters.
* Low Pass
* High Pass
* Band Pass
* Low Shelf
* High Shelf
* Peaking
* Notch
* All Pass

For more info, please read the [specification](http://www.w3.org/TR/webaudio/#BiquadFilterNode-section).

#### public methods
* `toggle(boolean)` bypass filter.
* `changeQuality(value)` changes Q factor of the filter.
* `changeFrequency(value)` changes cutoff frequency.

##Running local version
* Install all dependencies in your package.json
```shell
npm install 
```
* Run local Gruntfile
```shell
grunt
```