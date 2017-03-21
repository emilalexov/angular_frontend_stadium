define [
  './view'
], (
  SpinnerView
) ->

  class Module extends Marionette.Module

    initialize: ->
      @_initRegion()
      @_initSpinner()
      @_initHandlers()
      @

    _initRegion: ->
      @app.addRegions
        spinnerRegion: 'region[data-name="spinner"]'

    _initSpinner: ->
      @spinner = new SpinnerView

    _initHandlers: ->
      @listenTo @app.vent, 'spinner:start', =>
        @spinner.trigger('start')
      @listenTo @app.vent, 'spinner:stop', =>
        @spinner.trigger('stop')
      @listenTo @app, 'start', =>
        @_initAjax()
      @listenTo @app, 'start', =>
        @_showView()
        @spinner.trigger('start')
      @listenTo @app, 'started', =>
        setTimeout =>
          @spinner.trigger('stop')
        , 500

    _initAjax: =>
      @listenTo @app.vent, 'ajax:start', =>
        @app.vent.trigger('spinner:start')
      @listenTo @app.vent, 'ajax:complete', =>
        setTimeout =>
          if $.active is 0
            @app.vent.trigger('spinner:stop')
        , 100

    _showView: ->
      region = @app.getRegion('spinnerRegion')
      region.show(@spinner)
