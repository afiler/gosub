class Graphics
  constructor: (@canvas) ->
    
  circle: (x, y, radius) ->
    console.log 'Gcircle', arguments
    context = @canvas.getContext '2d'
    context.beginPath()
    context.arc x, y, radius, 0, 2 * Math.PI, false
    context.lineWidth = 1
    context.strokeStyle = 'green'
    context.stroke()

$ ->
  window.Graphics = new Graphics $('canvas')[0]