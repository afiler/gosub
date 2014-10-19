class @Id 
  constructor: (name, sigil=undefined) ->
    @name = name + (sigil || '')
    @sigil = sigil

  toString: ->
    "«" + @name + "»"

  resolve: (scope) ->
    scope[ident]

class @Call 
  constructor: (@ident, @args) ->

  toString: ->
    @ident.name + "(" + @args + ")"

  resolve: (resolver, scope) ->
    debug "Resolving call to %s", @ident
    resolved_fn = resolver(@ident)
    debug "resolved_fn %s", resolved_fn
    resolved_args = resolver(@args)
    debug "resolved_args %s length %d", jsDump.parse(resolved_args), resolved_args.length
    debug "resolved_args (%o)", resolved_args
    result = undefined
    
    # if (resolved_fn.constructor == Block) {
    #   result = window.gosub.call(resolved_fn)
    # } else {

    debug "Invoking #{@ident} with args (#{resolved_args})"
    result = resolved_fn.apply(scope, resolved_args)
    
    debug "applied result %s", result
    result

class @Block
  constructor: (@block) ->

  toString: ->
    "Block { " + @block + " }"

  apply: (that, args) =>
    window.gosub.call @

class @Span 
  constructor: (@elements) ->
    
  resolve: (scope) ->
    val = undefined
    elements.forEach (el) ->
      val = window.gosub.resolve(el)
      window.write el + "\n -> " + self.inspect(val)
      return

    val

class Symbol extends String
  constructor: (@_value) ->
  toString: ->
    "#{@_value}"

symbols = {}  
@Symbol = (str) ->
  unless symbols[str]
    symbols[str] = new Symbol(str)
  symbols[str]
