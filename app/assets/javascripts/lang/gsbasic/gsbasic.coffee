#= require jsDump

class @GsBasic
  constructor: (env) ->
    @scope = new @Main(env)
    

  run: (block) ->
    block.resolve(@resolve, @scope)

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
      el.resolve(@.resolve, @scope)
    else if el instanceof Array
      el.map (x) =>
        @resolve x
    
    # } else if (el.constructor == Block) {
    #       debug('Resolving block %s', el.block)
    #       return function() { window.gosub.call(el) }
    else
      debug "Value? %o", el
      el
