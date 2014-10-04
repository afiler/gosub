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
    
  write: (str) ->
    str = $('<div/>').text(str).html()
    @writeHtml str.replace('\n','<br/>')
    
  writeln: (str) ->
    @write "#{str}\n"
    
  writeHtml: (e) ->
    @terminal.append e
    @scrollToBottom()
  
  scrollToBottom: ->
    e = @terminal[0]
    e.scrollTop = e.scrollHeight

  cls: ->
    @terminal.html('')
