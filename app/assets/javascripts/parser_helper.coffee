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

@Id = (name, sigil) ->
  @name = name + ((if sigil then sigil else ""))
  @sigil = sigil
  @toString = ->
    "«" + @name + "»"

  @resolve = (scope) ->
    scope[ident]

  return

@Fn = (ident, args) ->
  @ident = ident
  @args = args
  @toString = ->
    @ident.name + "(" + args + ")"

  @resolve = (scope) ->
    scope[ident].call `undefined`, args

  return

@Tuple = (items) ->
  @items = items
  @toString = ->
    "Tuple(" + items.join(",") + ")"

  return

@Block = (block) ->
  self = this
  @block = block
  @toString = ->
    "Block { " + @block + " }"

  @apply = (that, args) ->
    window.gosub.call self

  return

@Span = (elements) ->
  @resolve = (scope) ->
    val = undefined
    elements.forEach (el) ->
      val = window.gosub.resolve(el)
      window.write el + "\n -> " + self.inspect(val)
      return

    val

  return
