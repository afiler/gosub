class Graphics
  constructor: (@canvas) ->

  circle: (x, y, radius, color) ->
    context = @canvas.getContext '2d'
    context.beginPath()
    context.arc x, y, radius, 0, 2 * Math.PI, false
    context.lineWidth = 1
    context.strokeStyle = color
    context.stroke()
    
  line: (fromX, fromY, toX, toY, color, lineStyle) ->
    context = @canvas.getContext '2d'
    context.beginPath()
    context.moveTo fromX, fromY
    context.lineTo toX, toY
    context.strokeStyle = color
    context.stroke()
    
  box: (fromX, fromY, toX, toY, color, fill, lineStyle) ->
    width = toX - fromX
    height = toY - fromY
    context = @canvas.getContext '2d'
    context.fillStyle = color
    context.strokeStyle = color
    context.fillRect fromX, fromY, width, height if fill
    context.strokeRect fromX, fromY, width, height
    context.stroke()
    
  point: (x, y, color) ->
    context = @canvas.getContext '2d'
    context.fillStyle = color
    context.fillRect x, y, 1, 1
    context.stroke()

$ ->
  window.Graphics = new Graphics $('canvas')[0]