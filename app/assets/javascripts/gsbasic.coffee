notImplemented = (features...) -> throw new Error("Not implemented, needs #{feature.join(',')} support")
NI = (features...) -> -> notImplemented(features...)
NOP = noOp = (arg) -> arg

@gsbasic = ->
  _DATA = []
  _ENVIRON = {}
  _ERRNO = null
  
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
  auto:           NI 'line numbering'
  beep:           NI 'sound'
  bload:          NI 'file'
  bsave:          NI 'file'
  call:           NI 'assembly'
  cdbl: (x) ->    Number(x) # FIXME?
  chain:          NI 'file', 'weird BASIC things'
  chdir:          NI 'file'
  chr$: (x) ->    String.fromCharCode(x)
  cint: (x) ->    Math.round(x) # FIXME
  circle:         NI 'graphics'
  clear:          NI 'weird BASIC things'
  close:          NI 'file'
  cls: ->         Screen.clear()
  color:          NI 'terminal'
  com:            NI 'serial'
  common:         NI 'weird BASIC things'
  cont:           NI 'break'
  cos: (x) ->     Math.cos(x)
  csng: (x) ->    Number(x) # FIXME?
  csrlin:         NI 'terminal'
  cvi:            NI 'serialization'
  cvs:            NI 'serialization'
  cvd:            NI 'serialization'
  data: (x...) -> _DATA.push x...
  date: -> # needs paren-less resolution
    now = new Date()
    "#{now.getMonth()}-#{now.getDate()}-#{now.getFullYear()}"
  defint:         NOP
  defsng:         NOP
  defdbl:         NOP
  defstr:         NOP
  delete:         NI 'line numbering'
  dim:            NOP # FIXME?
  draw:           NI 'graphics'
  edit:           NI 'line numbering'
  end:            NI 'weird BASIC things'
  environ: (str) ->
    [k, v] = String(str).split('-')
    _ENVIRON[k] = v
  environ$: (k) -> _ENVIRON[k]
  eof:            NI 'file'
  erase:          NOP
  erdev:          NI 'file', 'error'
  err:            NI 'error', 'paren-less resolution'
  erl:            NI 'error', 'line numbering', 'paren-less resolution'
  error: (errno, msg) ->
    _ERRNO = errno
    throw msg
  exp: (x) ->     Math.exp(x)
  exterr:         NI 'DOS'
  field:          NI 'file'
  files:          NI 'file'
  fix: (x) ->     sgn(x)*int(abs(x))
  for: (id, start, stop, step, forExpr) ->
    NI 'WIP'
  fre:            524288 # XXX?
  get:            NI 'file', 'graphics'
  gosub:          NI 'line numbering'
  goto:           NI 'line numbering'
  hex$: (x) ->    Number(x).toString(16)
  inkey$:         NI 'paren-less resolution'
  inp:            NI 'hardware'
  input:          NI 'terminal'
  input$:         NI 'terminal'
  'input#':       NI 'terminal'
  instr: (n, x$, y$=null) ->
    if y$ == null
      y$ = x$
      x$ = n
      n = 1
    String(x$).indexOf(y$, n-1) + 1
  int: (x) ->     Math.floor(x)
  ioctl:          NI 'file'
  ioctl$:         NI 'file'
  key:            NI 'terminal' # two variants, key and key()
  kill:           NI 'file'
  left: (x$, n) ->
    String(x$).substr(0, n)
  len: (x$) ->    String(x$).length
  line:           NI 'graphics'
  list:           NI 'terminal', 'line numbering'
  llist:          NI 'terminal', 'line numbering', 'printer'
  load:           NI 'file'
  loc:            NI 'file'
  locate:         NI 'terminal'
  lock:           NI 'file'
  lof:            NI 'file'
  log: (x) ->     Math.log(x)
  
  
  
  # unimplemented/needs syntax support
  # DATE$=v$
  # DEF FNAB(X, Y)=X^3/Y^2
  # DEF SEG=&HB800
  # DEF USR0=24000
  # LINE INPUT
  # LINE INPUT#