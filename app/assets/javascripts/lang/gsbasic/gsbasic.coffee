#= require jsDump

class @GsBasic
  constructor: (env) ->
    console.log 'Constructing a GsBasic'
    @scope = new @Main(env)
    
  _get: (k) ->
    console.log '_get', @
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

  resolve: (el) ->
    debug "resolve(%o)", el
    return unless el?

    if el instanceof Call
      debug "Resolving call to %s", el.ident
      resolved_fn = @resolve(el.ident)
      debug "resolved_fn %s", resolved_fn
      resolved_args = @resolve(el.args)
      debug "resolved_args %s length %d", jsDump.parse(resolved_args), resolved_args.length
      debug "resolved_args (%o)", resolved_args
      result = undefined
      
      # if (resolved_fn.constructor == Block) {
      #   result = window.gosub.call(resolved_fn)
      # } else {

      debug "Invoking #{el.ident} with args (#{resolved_args})"
      result = resolved_fn.apply(@scope, resolved_args)
      
      debug "applied result %s", result
      result
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
