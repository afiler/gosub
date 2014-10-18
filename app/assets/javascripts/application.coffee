#= require 'gosub'

@DEBUG = false

@debug = ->
  window.lastlog = arguments
  console.log.apply console, arguments  if DEBUG
  return

