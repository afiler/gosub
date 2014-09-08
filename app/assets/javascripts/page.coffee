pegUrl = '/assets/gosub.peg'

source = ->
  $('.source textarea').val()

screen = ->
  $('.screen')

build = ->
  $.get(pegUrl).then (grammar) ->
    parserSource = PEG.buildParser grammar,
      cache:    true,
      optimize: true,
      output:   "source"
    
    parser = eval parserSource
    output = parser.parse source()
    window.output = output
    screen().append($('<pre>').text(""+output))

window.build = build
