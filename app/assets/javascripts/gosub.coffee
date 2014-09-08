# ##################### 
window.gosub =
  scope: {}
  resetScope: ->
    window.gosub.scope =
      if: (a, b, c) ->
        debug "if(%s,%s,%s)", a, b, c
        (if a then b else c)

      "<": (l, r) ->
        l < r

      ">": (l, r) ->
        l > r

      "+": (l, r) ->
        l + r

      "-": (l, r) ->
        l - r

      "\\": (l, r) ->
        Number(l) / Number(r)

      mod: (l, r) ->
        l % r

      "/": (l, r) ->
        l / r

      "*": (l, r) ->
        l * r

      "==": (l, r) ->
        l is r

      print: (args) ->
        window.green args
        "green(" + args + ")"

      def: (k, v) ->
        console.log "DEF %s %s", k, v
        window.gosub.scope[k] = v

      let: (args) ->
        args

      _get: (k) ->
        v = window.gosub.scope[k]
        console.log "GET %s => %s", k, v
        if v
          window.gosub.scope[k]
        else
          console.log "UNDEFINED: %s", k
        return

    return

  run: (block) ->
    @resetScope()
    @call block
    return

  call: (block) ->
    self = this
    console.log block
    block.block.forEach (el) ->
      val = self.resolve(el)
      window.write el + "\n -> " + self.inspect(val)
      return

    block.block.forEach (el) ->
      val = self.resolve(el)
      window.write el + "\n -> " + self.inspect(val)
      return

    val

  inspect: (val) ->
    unless val
      "‘null’"
    else if val.constructor is String
      "\"" + val + "\""
    else
      val

  resolve: (el) ->
    debug "resolve(%o)", el
    return  unless el
    if el.constructor is Fn
      debug "Resolving Fn %s", el.id
      resolved_fn = self.resolve(el.id)
      debug "resolved_fn %s", resolved_fn
      resolved_args = self.resolve(el.args)
      debug "preresolved_args %s length %d", jsDump.parse(resolved_args), resolved_args.length
      debug "preresolved_args (%o)", resolved_args
      resolved_args = [resolved_args]  unless resolved_args.constructor is Array
      debug "resolved_args %s length %d", jsDump.parse(resolved_args), resolved_args.length
      debug "resolved_args (%o)", resolved_args
      result = undefined
      
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
      el.map (x) ->
        self.resolve x

    
    # } else if (el.constructor == Block) {
    #       debug('Resolving block %s', el.block)
    #       return function() { window.gosub.call(el) }
    else
      debug "Value? %o", el
      el