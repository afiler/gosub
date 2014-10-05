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

@Tuple = (@items) ->
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

class @Span 
  constructor: (@elements) ->
    
  resolve: (scope) ->
    val = undefined
    elements.forEach (el) ->
      val = window.gosub.resolve(el)
      window.write el + "\n -> " + self.inspect(val)
      return

    val

class @Symbol
  constructor: (val) ->
    @val = val.join ''
  
  toString: ->
    "##{@val}"
