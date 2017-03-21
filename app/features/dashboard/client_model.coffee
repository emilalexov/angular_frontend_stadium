define [
  './scheduled_workout_slider/collection'
], (
  WorkoutEventCollection
) ->

  class ClientDashboardModel extends Backbone.Model

    type: 'ClientDashboardModel'

    urlRoot: '/dashboards/client'

    constructor: (attrs, options) ->
      @workout_events = new WorkoutEventCollection([], user_id: options.user_id)

      @scheduled_workouts = new Backbone.VirtualCollection @workout_events,
        filter: (model) -> model.get('ends_at_int') > moment().valueOf()
        comparator: 'begins_at_int'

      @past_workouts = new Backbone.VirtualCollection @workout_events,
        filter: (model) -> model.get('ends_at_int') <= moment().valueOf()
        comparator: 'begins_at_int'

      super

    fetch: ->
      @workout_events.fetch
        data:
          range_from: moment().subtract(7, 'day').toString()
          range_to: moment().endOf('week').toString()
        processData: true
      super

    parse: (data) ->
      completed_count: data.events_completed_this_week_count
      scheduled_count: data.events_scheduled_this_week_count
