notImplemented = (features...) -> throw new Error("Not implemented, needs #{feature.join(',')} support")
NI = (features...) -> -> notImplemented(features...)
NOP = noOp = (arg) -> arg



Object.defineProperty Function::, 'autoresolve',
  get: ->
    @__autoresolve = true
    this
Function::__resolve = ->
  

class @GsBasic::Main
  constructor: (env) ->
    @_DATA = []
    @_DATA_IDX = 0
    @_ENVIRON = {}
    @_ERRNO = null
    @_fgcolor = 7
    @_bgcolor = 1
    @_lastPoint = [160, 120] # XXX
    
    @_screen = env.screen
    
    @scope = => @ # XXX
  
  pad2 = (number) ->
    ("0" + number).slice(-2)
    
  colorMap = (colorId) ->
    return colorId if colorId instanceof String
    return undefined if colorId == undefined
    return '#840' if colorId == 6
    return '#444' if colorId == 8
    
    digit = if 8 & colorId then 'F' else '8'
    r = 4 & colorId && digit
    g = 2 & colorId && digit
    b = 1 & colorId && digit
    "##{r}#{g}#{b}"
  
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
    return ['-', l, r] if l.constructor == Array
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

  def: (k, v) ->
    #@scope()[k] = v
    @[k] = v

  let: (args) ->
    args
    
  for: (id, start, stop, step, forExpr) ->
    NI 'WIP'
  
  run:  ((x)->    window.run()).autoresolve # XXX: support running a filename
  
  
  abs: (x) ->     Math.abs(x)
  asc: (x) ->     String(x).charCodeAt(0)
  atn: (x) ->     Math.atan(x)
  auto:           NI 'line numbering'
  beep: ->        Sound.play 400, 500
  bload:          NI 'file'
  bsave:          NI 'file'
  call:           NI 'assembly'
  cdbl: (x) ->    Number(x) # FIXME?
  chain:          NI 'file', 'weird BASIC things'
  chdir:          NI 'file'
  chr$: (x) ->    String.fromCharCode(x)
  cint: (x) ->    Math.round(x) # FIXME
  clear:          NI 'weird BASIC things'
  close:          NI 'file'
  cls: ->         Screen.clear()
  com:            NI 'serial'
  common:         NI 'weird BASIC things'
  cont:           NI 'break'
  cos: (x) ->     Math.cos(x)
  csng: (x) ->    Number(x) # FIXME?
  csrlin:         NI 'terminal'
  cvi:            NI 'serialization'
  cvs:            NI 'serialization'
  cvd:            NI 'serialization'
  data: (x...) -> @_DATA.push x...
  date$: (->
    now = new Date()
    "#{pad2 now.getMonth()}-#{pad2 now.getDate()}-#{now.getFullYear()}"
  ).autoresolve
  defint:         NOP
  defsng:         NOP
  defdbl:         NOP
  defstr:         NOP
  delete:         NI 'line numbering'
  dim:            NOP # FIXME?
  edit:           NI 'line numbering'
  end:            NI 'weird BASIC things'
  environ: (str) ->
    [k, v] = String(str).split('-')
    @_ENVIRON[k] = v
  environ$: (k) -> @_ENVIRON[k]
  eof:            NI 'file'
  erase:          NOP
  erdev:          NI 'file', 'error'
  err:            NI 'error', 'paren-less resolution'
  erl:            NI 'error', 'line numbering', 'paren-less resolution'
  error: (errno, msg) ->
    @_ERRNO = errno
    throw msg
  exp: (x) ->     Math.exp(x)
  exterr:         NI 'DOS'
  field:          NI 'file'
  files:          NI 'file'
  fix: (x) ->     sgn(x)*int(abs(x))
  fre:            524288 # XXX?
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
  list:           NI 'terminal', 'line numbering'
  llist:          NI 'terminal', 'line numbering', 'printer'
  load:           NI 'file'
  loc:            NI 'file'
  locate:         NI 'terminal'
  lock:           NI 'file'
  lof:            NI 'file'
  log: (x) ->     Math.log(x)
  lpos:           NI 'printer'
  lprint:         NI 'printer'
  lset:           NI 'syntax'
  merge:          NI 'file', 'line numbering'
  mid$: (x$, n, m) ->
    String(x$).substr(n-1, m)
  mkdir:          NI 'file'
  mkd$: (x) ->    String(x)
  mki$: (x) ->    String(x)
  mks$: (x) ->    String(x)
  name:           NI 'file'
  new:            NI 'line numbering'
  oct$: (x) ->    Number(x).toString(8)
  on:             NI 'events'
  open:           NI 'file'
  option: (base) ->
    NI 'fixme'
  out:            NI 'hardware'
  peek:           NI 'memory'
  pen:            NI 'hardware'
  play:           NI 'audio'
  poke:           NI 'memory'
  randomize:      NI 'prng'
  read: ->        
    error 0, 'Out of data' if @_DATA_IDX >= @_DATA.length # XXX: needs errno
    @_DATA[@_DATA_IDX++]
  rem: ->
  renum:          NI 'line numbers'
  reset:          NI 'file'
  restore: (line) ->
    return NI 'line numbers' if line
    @_DATA_IDX = 0
  resume:         NI 'error', 'line numbering'
  return:         NI 'ummmmmmmmm', 'line numbering'
  right$: (x$, n) ->
    String(x$).substr(0, 0-n)
  rmdir:          NI 'file'
  rnd: ->         Math.random()
  rset: ->        NI 'syntax'
  save:           NI 'file', 'bare arguments'
  sgn: (x) ->     `x > 0 ? 1 : x < 0 ? -1 : 0`
  shell:          NI 'os'
  sin: (x) ->     Math.sin(x)
  sound: (frequency, duration) ->
    Sound.play frequency, duration / 18.2 * 1000
  space$: (x) ->  Array(x+1).join(' ')
  spc:            @space$ # XXX is this the same thing? is it more like using tab()?
  sqr: (x) ->     Math.sqrt(x)
  stick:          NI 'joystick'
  stop:           NI 'ummmmmmmmm'
  str$: (x) ->    String(x)
  strig:          NI 'joystick'
  string$: (n, m) ->
    m = String.fromCharCode(m) if typeof m == number
    Array(n+1).join(String(m[0]))
  swap:           NI 'syntax'
  system:         NI 'ummmmmmmmm'
  tab:            NI 'terminal'
  tan: (x) ->     Math.tan(x)
  time: (->
    d = new Date()
    "#{pad2 d.getHours()}:#{pad2 d.getMinutes()}:#{pad2 d.getSeconds()}"
  ).autoresolve
  timer: (-> 
    Date.now()/1000 #/
  ).autoresolve
  tron:           NI 'ummmmmmmmm'
  troff:          NI 'ummmmmmmmm'
  unlock:         NI 'file'
  usr:            NI 'assembly'
  val: (x) ->     Number(x) # XXX: handle "&H" hex values
  varptr:         NI 'file', 'memory'
  varptr$:        NI 'memory'
  wait:           NI 'hardware'
  while: (cond, whileExpr) ->
    while(cond.resolve())
      whileExpr.resolve()
  width:          NI 'terminal'
  write: (args...) ->
    String(args...) # XXX: needs spaces between arguments?
  'write#':       NI 'file'
  
  # For statements with spaces
  base: ->        T('base', arguments)
  using: (template, args) ->
    NI 'fixme'
  B: 'B'
  BF: 'BF'
    
  # Applesoft
  get:            NI 'keyboard'
  htab:           NI 'terminal'
  vtab:           NI 'terminal'
  
  
  # GRAPHICS
  # temp parser bug kludgearound
  #circle: (xy, radius, color, start, end, aspect) ->
  circle: (x, y, radius, color, start, end, aspect) ->
    #console.log 'circle', arguments
    #console.log "Graphics.circle #{xy[0]}, #{xy[1]}, #{radius}, #{colorMap(color ? @_color)}"
    # temp parser bug kludgearound
    #@_screen.graphics.circle xy[0], xy[1], radius, colorMap(color)
    @_screen.graphics.circle x, y, radius, colorMap(color)
    
  draw:           NI 'graphics'
  
  line: (coords, color, options, style) ->
    throw 'Syntax error?' unless coords.constructor == Array and coords[0] == '-'
    from = if coords.length > 2 then coords[1] else @_lastPoint
    @_lastPoint = to = coords[2] # XXX support line -(x, y)
    
    if options == 'B' or options == 'BF'
      @_screen.graphics.box from[0], from[1], to[0], to[1], colorMap(color), options == 'BF'
    else
      @_screen.graphics.line from[0], from[1], to[0], to[1], colorMap(color)
    
  paint:          NI 'graphics'
  palette:        NI 'graphics'
  pmap:           NI 'graphics'
  point:          NI 'graphics'
  pos:            NI 'terminal'
  
  preset: (coords, color) ->
    @_screen.graphics.point coords.items[0], coords.items[1], colorMap(color)
  
  pset:           -> @preset(arguments...)
  
  view:           NI 'graphics'
  window:         NI 'graphics'
  
  # Applesoft
  gr:             NI 'graphics'
  plot:           NI 'graphics'
  hlin:           NI 'graphics'
  vlin:           NI 'graphics'
  
  # GRAPHICS/TERM
  color: (fgcolor, bgcolor) ->
    @_screen.fgcolor = colorMap(fgcolor) if fgcolor
    @_screen.bgcolor = colorMap(bgcolor) if bgcolor
    
  screen:         NI 'terminal', 'graphics'
  
  # GRAPHICS/FILE
  get:            NI 'file', 'graphics'
  put:            NI 'file', 'graphics'
  pcopy:          NI 'terminal', 'graphics'
  
  # TERMINAL
  print: (args...) ->
    for arg in args
      if arg.constructor == Symbol
        color = arg.val
      else
        @_screen.write arg, color
    @_screen.writeln()
    return
  
  
  # unimplemented/needs syntax support
  # DATA needs to execute upon parsing
  # DATE$=v$
  # DEF FNAB(X, Y)=X^3/Y^2
  # DEF SEG=&HB800
  # DEF USR0=24000
  # LINE INPUT
  # LINE INPUT#
  # LSET X$=Y$
  # MID$(A$, 14)="KS"
  # READ A(I)
  # RSET X$=Y$
