define [
  'modules/application/class'

  'deps/scripts'
  'deps/fonts'
  'deps/styles_vendor'
  'deps/styles_app'
], (
  Application
) ->

  $ ->
    window.App = new Application
    window.App.start()
