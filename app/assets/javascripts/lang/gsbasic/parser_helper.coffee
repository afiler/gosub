GsBasic.ParserHelper =
  call: ->
    args = [].slice.call(arguments)
    name = args.shift()
    new Call(new Id(name), args)
  
  jsStr: (a) ->
    a.join ""

  jsInt: (a, base) ->
    base = (if base then base else 10)
    parseInt a.join(""), base

  rollup: (head, tail) ->
    result = [head]
    i = 0

    while i < tail.length
      result.push tail[i][1]
      i++
    result

  flatten: ->
    [].concat.apply [], arguments
