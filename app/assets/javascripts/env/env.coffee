class @Gosub::Env
  constructor: (screenEl, sourceEl) ->
    @screen = new @Screen(screenEl)
    @source = $(sourceEl)