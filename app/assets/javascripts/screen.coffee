class @GsScreen
  constructor: (pane) ->
    @pane = $(pane)
    @input = @pane.find('.command-line')
    @terminal = @pane.find('.screen')
    
    @pane.find('form').on 'submit', (e) ->
      e.preventDefault()
      return unless @readlineCb
      
      @readlineCb(@input.val())
      @readlineCb = null
      
  readline: (cb) ->
    @readlineCb = cb
    
  write: (str, color) ->
    el = $('<span>').text(str).html().replace('\n','<br/>')
    el = $("<span style='color: #{color};'>").html(el) if color
    @writeHtml el
    
  writeln: (str='') ->
    @write "#{str}\n"
    
  writeHtml: (e) ->
    @terminal.append e
    @scrollToBottom()
  
  scrollToBottom: ->
    e = @terminal[0]
    e.scrollTop = e.scrollHeight

  cls: ->
    @terminal.html('')
