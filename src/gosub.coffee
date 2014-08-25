# debug = ->
#   window.lastlog = arguments
#   console.log.apply console, arguments  if DEBUG
#   return

window.debug = Function.prototype.bind.call(console.log, console);

DEBUG = true
window.gosub =
  run: (block) ->
    @call block
    return

  call: (block) ->
    self = this
    console.log block
    block.block.forEach (el) =>
      val = @resolve(el)
      window.write el + "\n" + val
      return val
      
  resolve: (el) ->
    debug "resolve(%o)", el
    return unless el
    
    if el.constructor is Fn
      debug "Resolving Fn %s", el.id
      resolved_fn = @resolve(el.id)
      debug "resolved_fn %s", resolved_fn
      resolved_args = @resolve(el.args)
      debug "preresolved_args %s length %d", jsDump.parse(resolved_args), resolved_args.length
      debug "preresolved_args (%o)", resolved_args
      resolved_args = [resolved_args]  unless resolved_args.constructor is Array
      debug "resolved_args %s length %d", jsDump.parse(resolved_args), resolved_args.length
      debug "resolved_args (%o)", resolved_args
  
      #var result
  
      # if (resolved_fn.constructor == Block) {
      #   result = window.gosub.call(resolved_fn)
      # } else {
      console.log resolved_fn
      result = resolved_fn.apply(window.gosub.scope, resolved_args)
  
      #}
      #var result = resolved_fn.apply(window.gosub.scope, resolved_args)
      #var result = resolved_fn(resolved_args[0], resolved_args[1], resolved_args[2])
      debug "applied result %s", result
      result
    else if el.constructor is Id
      val = window.gosub.scope._get(el.name)
      debug "Resolving Id %s => %s", el, val
      val
    else if el.constructor is Array
      debug "Resolving array %s", el
      el.map (x) =>
        @resolve x


    # } else if (el.constructor == Block) {
    #       debug('Resolving block %s', el.block)
    #       return function() { window.gosub.call(el) }
    else
      debug "Value? %o", el
      el