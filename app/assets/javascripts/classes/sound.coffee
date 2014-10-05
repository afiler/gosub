# maybe use http://0xfe.blogspot.ca/2011/08/generating-tones-with-web-audio-api.html to fix clicking?

class Sound
  constructor: () ->
    @context = new (AudioContext or WebkitAudioContext)()
  
  play: (frequency, ms, type) ->
    oscillator = @context.createOscillator()
    oscillator.connect @context.destination
    oscillator.frequency.value = frequency
    oscillator.type = oscillator[type.toUpperCase()] if type
    
    oscillator.start()
    setTimeout ->
      oscillator.stop()
    , ms
  
@Sound = new Sound()