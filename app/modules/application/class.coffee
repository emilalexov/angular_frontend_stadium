define [
  './initializers'
  './modules'
  'features/layouts/base/view'
  'modules/utils/hotjar'
  'modules/utils/mixpanel/module'
], (
  initializers
  modules
  BaseLayoutView
  hotjar
  mixpanel
) ->

  class Application extends Marionette.Application

    initialize: ->
      @listenTo(@, 'before:start', @_onBeforeStart)
      @listenTo(@, 'start', @_onStart)
      @listenTo(@, 'started', @_onStarted)
      @addInitializer -> initializers(@)

    start: ->
      super unless @_isStarted

    request: (handler) ->
      if @reqres.hasHandler(handler)
        super
      else
        msg = "handler is not defined - #{handler}"
        throw(Error(msg))

    _onBeforeStart: ->
      @_initPromises()
      @_initModules()
        .done(@promises.modules.resolve)
      @_initLayout()
        .done(@promises.layout.resolve)

    _onStart: ->
      defer = new $.Deferred

      @promises.modules
        .done =>
          @request('current_user:init:user')
            .then( =>
              @request('current_user:init:collections')
                .always(@promises.collections.resolve)
            )
            .fail(@promises.collections.resolve)
            .always(@promises.user.resolve)

      dfds = _.values(@promises)
      $.when(dfds...).done =>
        @_initHistory()
        return if @request('check:trial')
        @_openProgramPresetsLoader()
        defer.resolve()

      defer.done =>
        @_isStarted = true
        @trigger('started')

      defer.promise()

    _onStarted: ->
      feature.isEnabled('hotjar') && hotjar.init()
      feature.isEnabled('mixpanel') && mixpanel.init()

    _initPromises: ->
      names = [
        'modules'
        'layout'
        'user'
        'collections'
      ]
      @promises = _.reduce names, (memo, name) ->
        memo[name] = new $.Deferred
        memo
      , {}

    _initModules: ->
      defer = new $.Deferred
      modules(@)
      setTimeout ->
        defer.resolve()
      , 1000
      defer.promise()

    _initLayout: ->
      defer = new $.Deferred
      @baseView = new BaseLayoutView
      @baseView.once('render', defer.resolve)
      @baseView.render()
      defer.promise()

    _changeLocaltionHash: ->
      if not @request('current_user_id')
        path = window.location.hash
          .match(/^\#\/?(.*)$/)?[1] || ''
        exclusions = [
          /login/
          /signup/
          /reset/
          /prototype\/ui/
          /accessToken/
        ]
        exclusion = _.any exclusions, (rule) ->
          path.match(rule)
        unless exclusion
          window.location.replace('#login')

    _initHistory: ->
      @_changeLocaltionHash()
      @_startHistory()

    _startHistory: ->
      Backbone.history.start()

    _openProgramPresetsLoader: ->
      user = @request('current_user')
      settings = user.user_settings
      if user.get('is_pro') and !settings.get('is_presets_loaded')
        @request('base:accountTypes')
