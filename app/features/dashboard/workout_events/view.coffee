define [
  './item/view'
  './empty/view'
  './template'
], (
  ItemView
  EmptyView
  template
) ->

  class WorkoutEventsTableView extends Marionette.CompositeView

    className: 'tab-content'

    template: template

    templateHelpers: ->
      withStatus: @options.withStatus

    childView: ItemView

    childViewContainer: 'tbody'

    childViewOptions: ->
      withStatus: @options.withStatus

    emptyView: EmptyView

    ui:
      thead: 'thead'

    initialize: ->
      @listenTo(@collection, 'sync', @_onCollectionSizeChange)

    onShow: ->
      @_onCollectionSizeChange()

    _onCollectionSizeChange: ->
      if @collection.isEmpty()
        @ui.thead.hide()
      else
        @ui.thead.show()
