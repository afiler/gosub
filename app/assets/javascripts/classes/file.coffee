@File = (filename) ->
  if filename.match /^[a-zA-Z]\:/
    new LocalFile filename
  else
    new RemoveFile filename

class @LocalFile
  constructor: (@filename) ->
    @pos = 0
  
  read: (count=undefined) ->
    str = contents().slice(@pos, count)
    @pos = @pos + str.length
    str

  write: (data) ->
    localStorage.setItem contents().slice(0, @pos) + data

  contents: ->
    localStorage.getItem _key()

  _key: ->
    "file:#{filename}"

class @RemoteFile
  constructor: (@filename) ->
    # $.get(filename).then (file) ->
