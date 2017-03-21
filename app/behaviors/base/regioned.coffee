define ->

  class BaseRegionedBehavior extends Marionette.Behavior

    key: -> @regionName

    # NOTE: name of a region where to show the view
    regionName: undefined

    # NOTE: view constructor function
    behaviorViewClass: undefined

    # NOTE: view options to pass
    behaviorViewOptions: {}

    enabled: ->
      @_featureIsEnabled()

    defaults: {}

    initialize: ->
      super
      @isEnabled = if _.has(@options, 'enabled')
        _.bind(@options.enabled, @)()
      else
        _.result(@, 'enabled')
      @_initRegion()
      _.bindAll @, [
        '_initBehaviorView'
        '_renderBehaviorView'
      ]...
      if @isEnabled
        @listenTo(@view, 'before:show', @_initBehaviorView)
        @listenTo(@view, 'show', @_renderBehaviorView)
      @

    _initRegion: ->
      @view.addRegion(@regionName, @_getRegionSelector())

    _getRegionSelector: ->
      "region[data-name='#{@regionName}']"

    _initBehaviorView: ->
      options = _.result(@, 'behaviorViewOptions')
      @behaviorView = new @behaviorViewClass(options)

    _renderBehaviorView: ->
      @view.getRegion(@regionName)
        .show(@behaviorView)

    _featureIsEnabled: ->
      key = _.result(@, 'key')
      if feature.includes(key)
        feature.isEnabled(key)
      else
        true
