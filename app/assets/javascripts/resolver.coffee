#= require jsDump
#= require gsbasic

# ##################### 
window.gosub =
  scope: {}
  resetScope: ->
    window.gosub.scope = new GsBasic()
      
    window.gosub.scope._get = (k) ->
        v = window.gosub.scope[k]
        debug "GET %s => %s", k, v
        if v
          window.gosub.scope[k]
        else
          debug "UNDEFINED: %s", k

    return

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

    if el.constructor is Fn
      debug "Resolving Fn %s", el.ident
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
      result = resolved_fn.apply(window.gosub.scope, resolved_args)
      
      debug "applied result %s", result
      result
    else if el.constructor is Id
      val = window.gosub.scope._get(el.name)
      debug "Resolving Id %s => %s", el, val
      val = val.apply() if val and val.__autoresolve
      val
    else if el.constructor is Array
      el.map (x) =>
        @resolve x
    
    # } else if (el.constructor == Block) {
    #       debug('Resolving block %s', el.block)
    #       return function() { window.gosub.call(el) }
    else
      debug "Value? %o", el
      el
      
window.gosub.resetScope()
