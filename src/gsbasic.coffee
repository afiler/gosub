class GSBasic
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

  schmu: (args) ->
    console.log("schmu: #{args}")

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

window.gosub ||= {}
window.gosub.scope = new GSBasic()