class @GsScreen
  constructor: (pane) ->
    @canvas = $(pane).find('canvas')[0]
    @graphics = new Graphics(@canvas)
    @font = new Font('/fonts/cga_8x8.png', 8, 8)
    @fallbackFont = new Font('/fonts/unifont.png', 16, 16, true)
    @row = 0
    @col = 0
    @fgcolor = 'white'
    @bgcolor = 'black'
    @cursor(true)
    @inputBuffer = []
    #$('.command-line').on 'keypress', (e) => @keypress(e.originalEvent.charCode)
    $('.command-line').on 'input', (e) => @key(e.target)
    
  cursor: ->
    @_cursorBlink = @_cursorBlink + 1 & 1
    color = if @_cursorBlink then @bgcolor else @fgcolor
    @write ' ', @row, @col, @bgcolor, color
    setTimeout => # XXX
      @cursor()
    , 500
    
  key: (el) ->
    char = el.value
    el.value = ''
    @inputBuffer.push char
    write char
    
  keypress: (charCode) ->
    char = String.fromCharCode charCode
    @inputBuffer.push char
    write char
  
  readline: (cb) ->
    @readlineCb = cb
  
  writeln: (str='') ->
    @write "#{str}\n"
  
  write: (string, row, col, fgcolor, bgcolor, font) ->
    font ||= @font
    fgcolor ||= @fgcolor
    bgcolor ||= @bgcolor

    cw = font.hwCharWidth #font.charWidth
    ch = font.charHeight
    
    unless row?
      row = @row
      storeRow = true
    
    unless col?
      col = @col
      storeCol = true
    
    for c, i in string
      if c == '\n' or c == '\r'
        row = row + 1
        col = 0
      else
        if c <= '~'
          @graphics.writeChar c, col * cw, row * ch, fgcolor, bgcolor, font
        else
          @graphics.writeChar c, col * cw, row * ch, fgcolor, bgcolor, @fallbackFont, font.charWidth, font.charHeight

        col = col + 1

      if (col+1) * cw >= @canvas.width
        col = 0
        row = row + 1
      if (row+1) * ch >= @canvas.height
        @graphics.scroll ch
        row = row - 1

    @row = row if storeRow
    @col = col if storeCol
    return
        
  cls: ->
    #@terminal.html('')
