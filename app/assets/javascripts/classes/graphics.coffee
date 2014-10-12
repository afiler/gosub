class Graphics
  constructor: (@canvas) ->
    @font = new Font('/fonts/cga_8x8.png', 8, 8)

  context: (f) ->
    context = @canvas.getContext '2d'
    context.save()
    f(context)
    context.restore()
    
  circle: (x, y, radius, color) ->
    @context (c) ->
      c.beginPath()
      c.arc x, y, radius, 0, 2 * Math.PI, false
      c.lineWidth = 1
      c.strokeStyle = color
      c.stroke()
    
  line: (fromX, fromY, toX, toY, color, lineStyle) ->
    @context (c) ->
      c.beginPath()
      c.moveTo fromX, fromY
      c.lineTo toX, toY
      c.strokeStyle = color
      c.stroke()
    
  box: (fromX, fromY, toX, toY, color, fill, lineStyle) ->
    width = toX - fromX
    height = toY - fromY
    
    @context (c) ->
      c.fillStyle = color
      c.strokeStyle = color
      c.fillRect fromX, fromY, width, height if fill
      c.strokeRect fromX, fromY, width, height
      c.stroke()
    
  point: (x, y, color) ->
    @context (c) ->
      c.fillStyle = color
      c.fillRect x, y, 1, 1
      c.stroke()

  scroll: (y) ->
    @context (c) ->
      imageData = c.getImageData 0, y, c.canvas.width, c.canvas.height-y
      c.putImageData imageData, 0, 0
      c.clearRect 0, c.canvas.height-y, c.canvas.width, y
    
  writeString: (string, row, col, fgcolor, bgcolor, font) ->
    font ||= @font
    cw = font.charWidth
    ch = font.charHeight
    
    x = col * cw
    y = row * ch
    
    for c, i in string
      @writeChar c, x, y, fgcolor, bgcolor, font
      x = x + cw
      if x > @canvas.width
        x = 0
        y = y + ch
      if y > @canvas.height
        @scroll ch
        y = y - ch

    return

  writeChar: (char, x, y, fgcolor, bgcolor, font) ->
    font ||= @font
    [fontX, fontY] = font.charPos char
    cw = font.charWidth
    ch = font.charHeight
    
    @context (c) ->
      c.clearRect x, y, cw, ch
      c.drawImage font.img, fontX, fontY, cw, ch, x, y, cw, ch
      c.fillStyle = fgcolor
      c.globalCompositeOperation = 'source-atop'
      c.fillRect x, y, cw, ch
      c.fillStyle = bgcolor
      c.globalCompositeOperation = 'destination-over'
      c.fillRect x, y, cw, ch
    
class @Font
  constructor: (path, @charWidth, @charHeight) ->
    @img = new Image()
    @img.onload = =>
      @loaded = true
      @cellsPerRow = @img.width / @charWidth
    @img.src = path
    
  charPos: (char) ->
    charCode = char.charCodeAt(0)
    row = ~~(charCode / @cellsPerRow) # integer divide
    col = charCode % @cellsPerRow
    [col * @charWidth, row * @charHeight]

$ ->
  window.Graphics = new Graphics $('canvas')[0]