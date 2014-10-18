class @Gosub::Env::Screen
  constructor: (screen) ->
    @canvas = $(screen).find('canvas')[0]
    @graphics = new Graphics(@canvas)
    @font = new Font('/fonts/cga_8x8.png', 8, 8)
    @fallbackFont = new Font('/fonts/unifont.png', 16, 16, true)
    @row = 0
    @col = 0
    @fgcolor = 'white'
    @bgcolor = 'black'
    @inputBuffer = []
    @keygrabber = $(screen).find('.keygrabber')
    @keygrabber.on 'input', (e) => @charHandler(e)
    @keygrabber.on 'keydown', (e) => @keyHandler(e)
    @charHandler = (e) -> @char(e.target)
    @keyHandler = (e) -> @key(e)
    
    @queueUntilReady()
  
  queueUntilReady: ->
    queue = []
    _write = @write
    @write = (args...) ->
      queue.push ['write', args]
    
    @font.getReady.then =>
      @write = _write
      @onReady()
      for [f, args] in queue
        @write(args...)
  
  onReady: ->
    @cursor(true)

  cursor: ->
    @_cursorBlink = @_cursorBlink + 1 & 1
    @blinkCursor(@_cursorBlink)
    setTimeout => # XXX
      @cursor()
    , 500
    
  blinkCursor: (blink) ->
    color = if blink then @bgcolor else @fgcolor
    @write ' ', @row, @col, @bgcolor, color
  
  key: (e) ->
    if e.keyCode == 13
      text = @inputBuffer.join ''
      @inputBuffer = []
      @lineHandler(text) if @lineHandler
    else if e.keyCode == 8
      @backspace()
  
  char: (el) ->
    char = el.value
    el.value = ''
    @inputBuffer.push char
    write char
    
  readline: (cb) ->
    @readlineCb = cb
  
  backspace: ->
    @inputBuffer.pop()
    
    cw = @font.hwCharWidth #font.charWidth
    ch = @font.charHeight
    
    @col = @col - 1
    
    @_corralCursor()
    
  advance: ->
    @col++
    @_corralCursor()
    
    
  advanceLine: ->
    @row++
    @col = 0
    @_corralCursor()
  
  _corralCursor: ->
    cw = @font.hwCharWidth #@font.charWidth
    ch = @font.charHeight
    
    if (@col+1) * cw >= @canvas.width
      @col = 0
      @row = @row + 1
    if (@row+1) * ch >= @canvas.height
      @graphics.scroll ch
      @row = @row - 1
    if @col < 0
      @col = @canvas.width / cw - 1
      @row = @row - 1
    if @row < 0
      @row = 0

  writeln: (str='') ->
    @write "#{str}\n"
  
  write: (string, row, col, fgcolor, bgcolor, font) ->
    origFont = @font
    @font = font if font?
    if row?
      origRow = @row
      @row = row
    if col?
      origCol = @col
      @col = col
    fgcolor ||= @fgcolor
    bgcolor ||= @bgcolor

    cw = @font.hwCharWidth #font.charWidth
    ch = @font.charHeight
    
    for c, i in string
      if c == '\n' or c == '\r'
        @advanceLine()
      else
        if c <= '~'
          @graphics.writeChar c, @col * cw, @row * ch, fgcolor, bgcolor, @font
        else
          @graphics.writeChar c, @col * cw, @row * ch, fgcolor, bgcolor, @fallbackFont, cw, ch

        @advance()

    @row = origRow if origRow?
    @col = origCol if origCol?
    @font = origFont if origFont?
    return
        
  cls: ->
    #@terminal.html('')
