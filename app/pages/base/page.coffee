define [
  './model'
], (
  PageModel
) ->

  class BasePage extends Marionette.LayoutView

    className: 'gc-main-workspace'

    constructor: (@options) ->
      @_bindAll()
      @views = {}
      @model = new PageModel
      @_initData()
      super
      @_initEvents()
      @_syncData()
      @init()
      @_showPage()
      @

    init: ->

    initModel: ->
      # NOTE: building a view model

    initCollection: ->
      # NOTE: building a view collection

    initViews: ->
      # NOTE: building sub views
      {}

    regionViews: ->
      # NOTE: mapping of region and views
      {}

    _initData: ->
      @_initDataModel()
      @_initDataCollection()

    _initDataModel: ->
      model = @model.get('data.model')
      unless model instanceof Backbone.Model
        model = @initModel()
        if model instanceof Backbone.Model
          @model.set('data.model', model)

    _initDataCollection: ->
      collection = @model.get('data.collection')
      unless collection instanceof Backbone.Collection
        collection = @initCollection()
        if collection instanceof Backbone.Collection
          @model.set('data.collection', collection)

    _initEvents: ->
      @listenTo(@, 'before:show', @_initViews)
      @listenTo(@, 'views:show', @_showView)
      @listenTo(@model, 'change:state.subpage', (_model, state) =>
        @trigger('views:show', state)
      )
      @listenTo(@model.get('data.model'), 'destroy', @_onModelDestroy)

    _initViews: ->
      @views = _.result(@, 'initViews')

    _showView: (name, regionName) ->
      fn = _.result(@, 'views')[name]
      if typeof fn is 'function'
        fn = _.bind(fn, @)
      else
        return
      view = fn()
      regionName ||= 'page_content'
      region = @getRegion(regionName)
      region.show(view)

    _syncData: ->
      @_syncModel()
      @_syncCollection()

    _syncModel: ->
      model = @model.get('data.model')
      if _.any(model)
        model.fetch()

    _syncCollection: ->
      # FIXME: TBD

    _onModelDestroy: ->
      model = @model.get('data.model')
      namespace = _.chain(model.type)
        .pluralize()
        .underscored()
        .value()
      user = App.request('current_user')
      collection = user[namespace]
      model = collection.get(model.get('id'))
      model.stopListening() if model

    _showPage: ->
      App.request('views:show', @)
      @model.set('state.subpage', @options.state)
      @_showView(@model.get('state.subpage'))

    _bindAll: ->
      _.bindAll @, [
        'init'
        'initModel'
        'initCollection'
        'initViews'
        'regionViews'
        '_initData'
        '_initDataModel'
        '_initDataCollection'
        '_initEvents'
        '_initViews'
        '_showView'
        '_syncData'
        '_syncModel'
        '_syncCollection'
        '_showPage'
      ]...
