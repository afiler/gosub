#= require 'peg-0.8.0'
#= require 'jquery/dist/jquery'
#=
#= require_self
#=
#= require_tree './env'
#= require 'lang/gsbasic'

class @Gosub
  constructor: (screenEl, sourceEl) ->
    @env = new @Env(screenEl, sourceEl)
    @screen = @env.screen
    @source = $(sourceEl)

    @initPage()
    @initGsBasic()
    
  initGsBasic: ->
    @lang = new GsBasic(@env)
    @pegUrl = '/gosub.peg'
    @defaultFilename = 'a:/default.bas'
    @load @defaultFilename
    @load '/hello.bas' if @source.val() == ''

    writeln 'gosub.io BASIC'
    @buildParser().then =>
      writeln 'Ok'
      @takeInput()

  initPage: ->
    @source.on 'input', =>
      @save @defaultFilename, @source[0].value
        
    window.write = (text) =>
      @screen.write text
    
    window.writeln = (text) =>
      @screen.writeln text
    
    window.run = =>
      @runSource @source.val(), true
    

  
  buildParser: ->
    $.get("#{@pegUrl}?#{Date.now()}").then (grammar) =>
      parserSource = PEG.buildParser grammar,
        cache:    true,
        optimize: true,
        output:   "source"
    
      @parser = eval parserSource

  
  runSource: (source, debug=false) ->
    return if source.trim() == ""
    output = @parser.parse source
    writeln output if DEBUG
    parsedSource = @parser.parse(source)
    console.log 'AST', parsedSource.toString()
    @lang.run parsedSource
  
  setSource: (source) ->
    @source.val(source)
    
  load: (filename) ->
    if filename.match /^[a-zA-Z]\:/
      src = localStorage.getItem "file:#{filename}"
      @setSource(src) if src and src.trim() != ""
    else
      $.get(filename).then (file) =>
        @setSource file
  
  save: (filename, source) ->
    if filename.match /^[a-zA-Z]\:/
      localStorage.setItem "file:#{filename}", source
    else
      throw "BAD FILENAME"

  takeInput: ->
    @screen.lineHandler = (line) =>
      @lineHandler(line)
      write ']'
    write ']'

  lineHandler: (line) ->
    writeln ""
    result = @runSource(line)
    if result?
      write '-> '
      writeln result

$ ->
  screenEl = $('.screen')[0]
  sourceEl = $('.source')[0]

  window.gosub = new Gosub(screenEl, sourceEl)