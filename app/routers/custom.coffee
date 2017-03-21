module.exports = class CustomRouter extends Marionette.AppRouter
  route: (route, name, callback) ->
    route = @_routeToRegExp(route)  unless _.isRegExp(route)
    if _.isFunction(name)
      callback = name
      name = ''
    callback = @[name]  unless callback
    router = @
    Backbone.history.route route, (fragment) ->
      args = router._extractParameters(route, fragment)
      if router.before?
        router.before.apply router, [name].concat(args)
      router.execute callback, args
      router.trigger.apply router, ['route:' + name].concat(args)
      router.trigger 'route', name, args
      if router.after?
        router.after.apply router, [name].concat(args)
      Backbone.history.trigger 'route', router, name, args
      return
  onRoute: (name, path, opts)->
    @_setBodyClass name
    App.request 'lastHash:set',
      hash: window.location.hash
      action: name

  _setBodyClass: (route) ->
    if route is 'login' or route is 'signUp'
      document.body.style.overflow = 'auto'
    else
      document.body.style.overflow = ''