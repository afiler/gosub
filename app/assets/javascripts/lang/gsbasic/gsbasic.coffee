#= require jsDump

class @GsBasic
  constructor: (env) ->
    @scope = new @Main(env)
    
  _get: (k) ->
    v = @scope[k]
    debug "GET %s => %s", k, v
    if v
      @scope[k]
    else
      throw "UNDEFINED: #{k}"

  run: (block) ->
    @call block

  call: (block) ->
    #console.log block
    val = undefined
    block.block.forEach (el) =>
      val = @resolve(el)
      #window.writeln el
      #window.writeln " -> " + @inspect(val)

    return val

  inspect: (val) ->
    unless val
      "‘null’"
    else if val.constructor is String
      "\"" + val + "\""
    else
      val

  resolve: (el) =>
    debug "resolve(%o)", el
    return unless el?

    if el instanceof Call
      el.resolve(@.resolve, @scope)
    else if el instanceof Id
      val = @_get(el.name)
      debug "Resolving Id %s => %s", el, val
      val = val.apply() if val and val.__autoresolve
      val
    else if el instanceof Array
      el.map (x) =>
        @resolve x
    
    # } else if (el.constructor == Block) {
    #       debug('Resolving block %s', el.block)
    #       return function() { window.gosub.call(el) }
    else
      debug "Value? %o", el
      el
