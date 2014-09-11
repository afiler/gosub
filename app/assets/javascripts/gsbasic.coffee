NI = notImplemented = (features...) -> throw new Error("Not implemented, needs #{feature.join(',')} support")
NOP = noOp = (arg) -> arg

@gsbasic = ->
  _DATA = []
  _ENVIRON = {}
  
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

  
  abs: (x) ->     Math.abs(x)
  asc: (x) ->     String(x).charCodeAt(0)
  atn: (x) ->     Math.atan(x)
  auto: ->        NI 'line numbering'
  beep: ->        NI 'sound'
  bload: ->       NI 'file'
  bsave: ->       NI 'file'
  call: ->        NI 'assembly'
  cdbl: (x) ->    Number(x) # FIXME?
  chain: ->       NI 'file', 'weird BASIC things'
  chdir: ->       NI 'file'
  chr$: (x) ->    String.fromCharCode(x)
  cint: (x) ->    Math.round(x) # FIXME
  circle: ->      NI 'graphics'
  clear: ->       NI 'weird BASIC things'
  close: ->       NI 'file'
  cls: ->         Screen.clear()
  color: ->       NI 'fancy terminal'
  com: ->         NI 'serial'
  common: ->      NI 'weird BASIC things'
  cont: ->        NI 'break'
  cos: (x) ->     Math.cos(x)
  csng: (x) ->    Number(x) # FIXME?
  csrlin: (x) ->  NI 'fancy terminal'
  cvi: (x) ->     NI 'serialization'
  cvs: (x) ->     NI 'serialization'
  cvd: (x) ->     NI 'serialization'
  data: (x...) -> _DATA.push x...
  date: -> # needs paren-less resolution
    now = new Date()
    "#{now.getMonth()}-#{now.getDate()}-#{now.getFullYear()}"
  defint:         NOP
  defsng:         NOP
  defdbl:         NOP
  defstr:         NOP
  delete: ->      NI 'line numbering'
  dim:            NOP # FIXME?
  draw: ->        NI 'graphics'
  edit: ->        NI 'line numbering'
  end: ->         NI 'weird BASIC things'
  environ: (str) ->
    k, v = String(str).split('-')
    _ENVIRON[k] = v
  environ$: (k) -> _ENVIRON[k]
  eof: ->         NI 'file'
  erase:          NOP
  erdev:          NI 'file', 'error'
  err:            NI 'error', 'paren-less resolution'
  erl:            NI 'error', 'line numbering', 'paren-less resolution'
  error: ()
  
  
  # unimplemented/needs syntax support
  # DATE$=v$
  # DEF FNAB(X, Y)=X^3/Y^2
  # DEF SEG=&HB800
  # DEF USR0=24000