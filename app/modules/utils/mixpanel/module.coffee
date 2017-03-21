define [
  'config'
  './init'
  './tracking'
], (
  config
  init
  tracking
) ->

  init: ->
    token = config.vendor.mixpanel?.token
    return false unless token
    init(document, window.mixpanel || [])
    window.mixpanel.init(token)
    tracking.init(App)
    true
