define [
  'features/layouts/base/view'
  'features/layouts/main/view'
  'features/layouts/auth/view'
], (
  BaseLayoutView
  MainLayoutView
  AuthLayoutView
) ->

  class RendererHandler

    defaults:
      base:
        klass: BaseLayoutView
        region: 'appRegion'
      main:
        klass: MainLayoutView
        region: 'content'
      auth:
        klass: AuthLayoutView
        region: 'content'

    constructor: (app) ->
      @app = app
      @_initHandlers()
      @

    _initHandlers: ->
      @app.reqres.setHandler('views:show', @_show)

    _show: (view, opts = {}) =>
      unless _.has(view, 'render')
        msg = "view is expected, got #{view}"
        throw(Error(msg))
        return
      options = _.defaults opts,
        layout: 'main'
      options.region = options.region || @defaults[options.layout]['region']

      if options.layout isnt 'base'
        @_ensureLayoutIs(options.layout)
      layout = @app.request("app:layouts:#{options.layout}")
      region = layout.getRegion(options.region)
      region.show(view)

    _ensureLayoutIs: (name) =>
      @_switchLayoutTo(@defaults[name]['klass'])

    _switchLayoutTo: (klass) =>
      baseLayout = @app.request('app:layouts:base')
      region = baseLayout.getRegion('appRegion')
      currentView = region.currentView
      unless region.hasView() and currentView instanceof klass
        view = new klass
        region.show(view)

  (app) ->

    new RendererHandler(app)
