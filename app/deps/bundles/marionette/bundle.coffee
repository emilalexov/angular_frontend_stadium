define [
  'deps/bundles/backbone/bundle'
  './original'
  './dirty_hack'
  'deps/behaviors'
  'backbone.wreqr'
  'backbone.babysitter'
], (
  bBackbone
  oMarionette
  DirtyHack
  behaviors
)->

  oMarionette
  oMarionette.Backbone = bBackbone
  bBackbone.Marionette = oMarionette

  if feature.isEnabled('tooltips_tour')
    oMarionetteView = oMarionette.View
    oMarionette.View = ->
      oMarionetteView.apply(@, arguments)
      @listenToOnce @, 'show', ->
        App.vent.trigger('app:view:show', @)
      @listenToOnce @, 'before:destroy', ->
        App.vent.trigger('app:view:destroy', @)
      return
    _.extend(oMarionette.View.prototype, oMarionetteView.prototype)

  _.extend(oMarionette.View.prototype, bBackbone.Stickit.ViewMixin)

  DirtyHack(oMarionette)
  oMarionette.Behaviors.behaviorsLookup = behaviors
  oMarionette
