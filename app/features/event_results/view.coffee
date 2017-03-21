define [
  './template'
  './event_exercises/view'
  './comments/view'
], (
  template
  EventExerciseCollectionView
  CommentsLayoutView
) ->

  class EventExerciseLayoutView extends Marionette.LayoutView

    template: template

    className: 'gc-box-content'

    behaviors: ->

      regioned:
        views: [
            region: 'event_exercises'
            klass: EventExerciseCollectionView
            options: ->
              collection: @model.exercises
          ,
            region: 'comments'
            klass: CommentsLayoutView
            options: ->
              collection: @model.comments
        ]

    events:
      'click .type-delete': '_removeAllResults'
      'click .finish': '_completeEvent'

    _removeAllResults: ->
      @views.event_exercises.trigger('remove:results')

    _completeEvent: ->
      @model.finish()
        .done =>
          App.vent.trigger('mixpanel:track', 'workout_finished', @model)
          App.vent.trigger('redirect:to', ['welcome'], replace: false)
