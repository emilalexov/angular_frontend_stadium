define ->

  class RegionedBehavior extends Marionette.Behavior

    key: 'regioned'

    defaults:
      views: []

    initialize: ->
      @_bindAll()
      @view.views ?= {}
      super
      @

    onBeforeShow: ->
      @_initRegions()
      @_initBehaviorViews()

    onShow: ->
      @_ensureDataIsSynced()
        .done =>
          @_renderBehaviorViews()

    _ensureDataIsSynced: ->
      defer = new $.Deferred
      dfds = {}
      _.each ['model', 'collection'], (namespace) =>
        data = @view[namespace]
        dfds[namespace] = new $.Deferred
        dfd = dfds[namespace]
        if data and data._isRequested
          @listenToOnce(data, 'sync', ->
            dfd.resolve())
        else
          dfd.resolve()
      $.when(_.values(dfds)...).then(defer.resolve)
      defer.promise()

    _initRegions: ->
      @_doForEachViewOption (viewOption) =>
        selector = @_getRegionSelector(viewOption.region)
        @view.addRegion(viewOption.region, selector)

    _getRegionSelector: (regionName) ->
      "region[data-name='#{regionName}']"

    _initBehaviorViews: ->
      @_doForEachViewOption (viewOption) =>
        viewOption.options ?= -> @options
        viewOption.enabled ?= -> true
        options = _.bind(viewOption.options, @view)()
        @view.views[viewOption.region] = new viewOption.klass(options)

    _renderBehaviorViews: ->
      @_doForEachViewOption (viewOption) =>
        enabled = _.bind(viewOption.enabled, @view)()
        v = @view.views[viewOption.region]
        if enabled
          @view.getRegion(viewOption.region)?.show(v)

    _doForEachViewOption: (fn) ->
      _.each(@options.views, fn)

    _bindAll: ->
      fns = [
        '_initRegions'
        '_initBehaviorViews'
        '_renderBehaviorViews'
        '_doForEachViewOption'
      ]
      _.bindAll(@, fns...)
