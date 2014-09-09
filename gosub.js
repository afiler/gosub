DEBUG = true

function debug() {
  window.lastlog = arguments
  if (DEBUG) console.log.apply(console, arguments)
}

function jsStr(a) { return a.join('') }
function jsInt(a, base) { var base = base ? base : 10; return parseInt(a.join(''), base) }

function rollup(head, tail) {
  var result = [head];
  for (var i = 0; i < tail.length; i++) { result.push(tail[i][1]); }
  return result;
}

function flatten() {
  return [].concat.apply([], arguments)
}

Id = function(name, sigil) {
  this.name = name+(sigil ? sigil : '');
  this.sigil = sigil;
  this.toString = function() { return "«"+this.name+"»" }
  this.resolve = function(scope) { return scope[id] }
}

Fn = function(id, args) {
  this.id = id
  this.args = args;
  this.toString = function() { return this.id.name+"("+args+")" }
  this.resolve = function(scope) { return scope[id].call(undefined, args) }
}

Tuple = function(items) {
  this.items = items
  this.toString = function() { return "Tuple("+items.join(',')+")" }
}

Block = function(block) {
  var self = this
  this.block = block
  this.toString = function() { return "Block { "+this.block+" }" }
  this.apply = function(that, args) {
    return window.gosub.call(self)
  }
}

Span = function(elements) {
  this.resolve = function(scope) {
    var val
    elements.forEach(function (el) {
      val = window.gosub.resolve(el)
      window.write(el + "\n -> " + self.inspect(val))
    })
    return val
  }
}
  
/* ##################### */
window.gosub = {
  scope: {},
  
  resetScope: function() {
    window.gosub.scope = {
      'if': function(a, b, c) { debug("if(%s,%s,%s)", a, b, c); return a ? b : c },
      '<': function(l, r) { return l < r },
      '>': function(l, r) { return l > r },
      '+': function(l, r) { return l + r },
      '-': function(l, r) { return l - r },
      '\\': function(l, r) { return Number(l) / Number(r) },
      mod: function(l, r) { return l % r },
      '/': function(l, r) { return l / r },
      '*': function(l, r) { return l * r },
      '==': function(l, r) { return l === r},
    
      print: function(args) { window.green(args); return "green("+args+")" },
      def: function(k, v) { console.log('DEF %s %s', k, v); return window.gosub.scope[k] = v },
      let: function(args) { return args },
      _get: function(k) { v = window.gosub.scope[k];  console.log('GET %s => %s', k, v);  if (v) return window.gosub.scope[k]; else console.log('UNDEFINED: %s', k) },
    }
  },

  run: function(block) {
    this.resetScope();
    this.call(block);
  },
  
  call: function(block) {
    self = this
    console.log(block)
    block.block.forEach(function (el) {
      val = self.resolve(el)
      window.write(el + "\n -> " + self.inspect(val))
    })
    
    block.block.forEach(function (el) {
      val = self.resolve(el)
      window.write(el + "\n -> " + self.inspect(val))
    })
    
    
    return val
  },
  
  inspect: function(val) {
    if (!val) return '‘null’';
    else if (val.constructor == String) return '"'+val+'"'
    else return val;
  },

  resolve: function (el) {
    debug('resolve(%o)', el)
    if (!el) return
      
    if (el.constructor == Fn) {
      debug('Resolving Fn %s', el.id)
      var resolved_fn = self.resolve(el.id); debug('resolved_fn %s', resolved_fn)
      var resolved_args = self.resolve(el.args)
      debug('preresolved_args %s length %d', jsDump.parse(resolved_args), resolved_args.length)
      debug('preresolved_args (%o)', resolved_args)
      if (resolved_args.constructor != Array) resolved_args = [resolved_args]
      debug('resolved_args %s length %d', jsDump.parse(resolved_args), resolved_args.length)
      debug('resolved_args (%o)', resolved_args)
      
      var result
      
      // if (resolved_fn.constructor == Block) {
      //   result = window.gosub.call(resolved_fn)
      // } else {
        console.log(resolved_fn)
        result = resolved_fn.apply(window.gosub.scope, resolved_args)
        //}
      //var result = resolved_fn.apply(window.gosub.scope, resolved_args)
      //var result = resolved_fn(resolved_args[0], resolved_args[1], resolved_args[2])
      debug('applied result %s', result)
    
      return result
    } else if (el.constructor == Id) {
      var val = window.gosub.scope._get(el.name)
      debug('Resolving Id %s => %s', el, val)
      return val
    } else if (el.constructor == Array) {
      debug('Resolving array %s', el)
      return el.map(function(x) { return self.resolve(x) })
    // } else if (el.constructor == Block) {
//       debug('Resolving block %s', el.block)
//       return function() { window.gosub.call(el) }
    } else {
      debug('Value? %o', el)
      return el
    }
  }
}
