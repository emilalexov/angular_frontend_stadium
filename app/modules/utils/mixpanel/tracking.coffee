define [
  './events'
], (
  mixpanelEvents
) ->

  class MixPanelTracking

    constructor: (@app) ->
      @__defineGetter__ 'mixpanel', ->
        window.mixpanel
      @_initVent()
      @_initSuperProperties()
      @

    _initVent: ->
      @app.vent.listenTo @app.vent,
        'mixpanel:track': @_track
      @app.vent.listenTo @app.vent,
        'mixpanel:identify': @_identify
      @app.vent.listenTo @app.vent,
        'mixpanel:sign_up': @_signUp
      @app.vent.listenTo @app.vent,
        'mixpanel:sign_in': @_signIn
      @app.vent.listenTo @app.vent,
        'mixpanel:sign_out': @_signOut
      @app.vent.listenTo @app.vent,
        'mixpanel:userUpdate': @_userUpdate

    _initSuperProperties: ->
      @mixpanel.register
        app: 'webapp'

    _track: (event, object, attrs = {}) =>
      map = mixpanelEvents[event]
      return unless map
      properties = @_prepareTrackedProperties(map, object, attrs)
      @_trackActivity()
      @mixpanel.track(event, properties)

    _prepareTrackedProperties: (map, object, attrs) ->
      properties = {}

      modelAttrs = map.model
      if _.any(modelAttrs)
        $.extend(true, properties, object.pick(modelAttrs...))

      extraAttrs = map.extra
      if _.isFunction(extraAttrs)
        $.extend(true, properties, extraAttrs(object, attrs))

      properties

    _identify: (model) =>
      model or= @app.request('current_user')
      id = model.get('id')
      @_trackActivity()
      @mixpanel.identify("#{id}")
      if not @mixpanel.get_property('email')
        @_fillUserProperties(model)

    _signUp: (model) =>
      @_identify(model)
      @mixpanel.track('sign_up')

    _signIn: (model) =>
      @_identify(model)
      @mixpanel.track('sign_in')

    _signOut: =>
      @mixpanel.track('sign_out')
      @mixpanel.reset()

    _userUpdate: (model) =>
      @_fillUserProperties(model)

    _fillUserProperties: (model) ->
      attrs = @_preparePersonAttrs(model)
      @mixpanel.people.set(attrs)

    _trackActivity: ->
      @mixpanel.people.set
        $last_login: new Date()

    _preparePersonAttrs: (model) ->
      $email: model.get('email')
      $first_name: model.get('user_profile.first_name')
      $last_name: model.get('user_profile.last_name')

  init: (app, mixpanel) ->
    new MixPanelTracking(app, mixpanel)
