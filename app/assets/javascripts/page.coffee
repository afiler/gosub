pegUrl = '/gosub.peg'

source = ->
  $('.source').val()

screen = ->
  $('.screen')

build = ->
  $.get("#{pegUrl}?#{Date.now()}").then (grammar) ->
    parserSource = PEG.buildParser grammar,
      cache:    false,
      optimize: false,
      output:   "source"
    
    parser = eval parserSource
    parser.parse source()

window.run = ->
  build().then (output) ->
    window.write output
  
    window.gosub.run output

window.write = (text) ->
  screen().append($('<p>').text(""+text))

window.green = (text) ->
  screen().append($('<p style="color: yellow">').text(""+text))

$ ->
  $.get('/test.bas').then (file) ->
    $('.source').val(file)