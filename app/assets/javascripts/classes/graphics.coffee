class @Graphics
  constructor: (@canvas) ->

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

  writeChar: (char, x, y, fgcolor, bgcolor, font, destCharWidth, destCharHeight) ->
    [fontX, fontY] = font.charPos char
    cw = font.hwCharWidth #font.charWidth
    ch = font.charHeight
    destCharWidth ||= cw
    destCharHeight ||= ch
    
    @context (c) ->
      c.clearRect x, y, destCharWidth, destCharHeight
      c.drawImage font.img, fontX, fontY, cw, ch, x, y, destCharWidth, destCharHeight
      c.fillStyle = fgcolor
      c.globalCompositeOperation = 'source-atop'
      c.fillRect x, y, destCharWidth, destCharHeight
      c.fillStyle = bgcolor
      c.globalCompositeOperation = 'destination-over'
      c.fillRect x, y, destCharWidth, destCharHeight
    
class @Font
  constructor: (path, @charWidth, @charHeight, fullwidth=false) ->
    @hwCharWidth = if fullwidth then @charWidth / 2 else @charWidth

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
