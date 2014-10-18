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
    return if source.trim() == ""
    output = @parser.parse source
    window.writeln output if DEBUG
    parsedSource = @parser.parse(source)
    console.log 'AST', parsedSource.toString()
    window.parsedSource = parsedSource
    window.gosub.run parsedSource

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
    $('.keygrabber').focus()
    
    load 'a:/default.bas'
    load '/hello.bas' if source() == ''
    
    lineHandler = (line) ->
      writeln ""
      #return window.run() if line.toLowerCase() == 'run' # XXX
      result = runSource(line)
      write '-> '
      writeln result
      $('.command-line').val('')
    
    # XXX
    setTimeout ->
      writeln 'gosub.io BASIC'
      scr.lineHandler = lineHandler
      buildParser().then ->
        writeln 'Ok'
      
    , 1000
    
      
    $('.source').on 'input', ->
      save 'a:/default.bas', @.value