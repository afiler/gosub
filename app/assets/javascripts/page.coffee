#= require 'screen'

class GosubEnv
  pegUrl = '/gosub.peg'

  source = ->
    $('.source').val()

  screen = ->
    $('.screen')

  buildParser = ->
    $.get("#{pegUrl}?#{Date.now()}").then (grammar) =>
      parserSource = PEG.buildParser grammar,
        cache:    true,
        optimize: true,
        output:   "source"
    
      @parser = eval parserSource

  window.run = ->
    runSource source(), true
  
  runSource = (source, debug=false) ->
    output = @parser.parse source
    window.write output if debug
    window.gosub.run @parser.parse(source)

  window.write = (text) ->
    scr.write text
    
  window.writeln = (text) ->
    scr.writeln text
  
  window.green = (text) ->
    scr.writeHtml $('<p style="color: yellow">').text(""+text)

  $ ->
    window.scr = new GsScreen $('.screen-pane')
    scr.cls()
    $.get('/test.bas').then (file) ->
      $('.source').val(file)
    
    writeln 'Building parser'
    buildParser().then ->
      writeln 'Parser built'
    
    $('.screen-pane form').on 'submit', (e) ->
      e.preventDefault()
      source = $('.command-line').val()
      runSource source, true
      $('.command-line').val('')