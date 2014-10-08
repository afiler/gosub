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
    window.writeln output if debug
    window.gosub.run @parser.parse(source)

  window.write = (text) ->
    scr.write text
    
  window.writeln = (text) ->
    scr.writeln text
  
  setSource = (source) ->
    $('.source').val(source)
    
  window.load = (filename) ->
    if filename.match /^[a-zA-Z]\:/
      src = localStorage.getItem "file:#{filename}"
      setSource(src) if src and src.trim() != ""
    else
      $.get(filename).then (file) ->
        setSource file
  
  save = (filename, source) ->
    if filename.match /^[a-zA-Z]\:/
      localStorage.setItem "file:#{filename}", source
    else
      throw "BAD FILENAME"

  $ ->
    window.scr = new GsScreen $('.screen-pane')
    scr.cls()
    load 'a:/default.bas'
    load '/hello.bas' if source() == ''
    
    writeln 'gosub.io BASIC'
    buildParser().then ->
      writeln 'Ok'
    
    $('.screen-pane form').on 'submit', (e) ->
      e.preventDefault()
      src = $('.command-line').val()
      scr.write '<- '
      scr.writeln src
      result = runSource(src)
      scr.write '-> '
      scr.writeln result
      $('.command-line').val('')
      
    $('.source').on 'input', ->
      save 'a:/default.bas', @.value