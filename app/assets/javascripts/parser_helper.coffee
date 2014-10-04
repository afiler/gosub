@debug = ->
  window.lastlog = arguments
  console.log.apply console, arguments  if DEBUG
  return

@jsStr = (a) ->
  a.join ""

@jsInt = (a, base) ->
  base = (if base then base else 10)
  parseInt a.join(""), base

@rollup = (head, tail) ->
  result = [head]
  i = 0

  while i < tail.length
    result.push tail[i][1]
    i++
  result

@flatten = ->
  [].concat.apply [], arguments

@DEBUG = true