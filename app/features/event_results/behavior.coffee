define [
  './new_event_model'
], (
  Event
) ->

  class EnterResultsForNewWorkoutEvent extends Marionette.Behavior

    key: 'enter_results_for_new_workout_event'

    events:
      'click [enter-results]': '_createWorkoutEvent'

    _createWorkoutEvent: ->
      event = new Event
        personal_workout_id: _.result(@options, 'id')
        begins_at: moment().format()
        ends_at: moment().add(1, 'hour').format()

      event
        .save()
        .then ->
          path = ['events', event.id, 'results']
          App.vent.trigger('redirect:to', path)
