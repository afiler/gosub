pegUrl = '/gosub.peg'

source = ->
  $('.source').val()

screen = ->
  $('.screen')

build = ->
  $.get(pegUrl).then (grammar) ->
    parserSource = PEG.buildParser grammar,
      cache:    true,
      optimize: true,
      output:   "source"
    
    parser = eval parserSource
    parser.parse source()

window.run = ->
  build().then (output) ->
    window.write output
  
    window.gosub.run output

window.write = (text) ->
  screen().append($('<pre>').text(""+text))

window.green = (text) ->
  screen().append($('<pre style="color: yellow">').text(""+text))

$ ->
  $.get('/test.bas').then (file) ->
    $('.source').val(file)