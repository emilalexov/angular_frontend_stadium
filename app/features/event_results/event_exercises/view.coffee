define [
  './item/view'
], (
  EventExerciseItemView
) ->

  class EventExerciseCollectionView extends Marionette.CollectionView

    childView: EventExerciseItemView

    behaviors:
      exercises_connectors: true

    initialize: ->
      @listenTo(@, 'remove:results', @_removeAllResults)

    _removeAllResults: ->
      App.request 'modal:confirm',
        title: 'Remove All results?'
        content: 'Are you sure you want remove all results?'
        confirmBtn: 'Confirm'
        confirmCallBack: =>
          @children.each((view) -> view.trigger('remove:results'))
