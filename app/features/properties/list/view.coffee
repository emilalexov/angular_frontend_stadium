define [
  './empty/view'
  './item/view'
  './template'
], (
  EmptyView
  ItemView
  template
) ->

  class PropertyListView extends Marionette.CompositeView

    template: template

    emptyView: EmptyView

    childView: ItemView

    childViewContainer: 'ul'

    initialize: ->
      @listenTo(App.vent, 'drag_n_drop:item:dropped', @_updatePosition)

    childViewOptions: (model, index) ->
      attributes:
        'data-id': model.id

    viewComparator: (model) ->
      model.get('position')

    templateHelpers: =>
      collection: @collection

    _updatePosition: ->
      @children.each (view) ->
        view.model.set
          position: view.$el.index()
        view.model.patch()