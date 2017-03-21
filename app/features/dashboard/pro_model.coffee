define [
  './scheduled_workout_slider/collection'
  './client_performance/collection'
], (
  WorkoutEventCollection
  ClientPerformance
) ->

  class ProDashboardModel extends Backbone.Model

    type: 'ProDashboardModel'

    urlRoot: '/dashboards/pro'

    constructor: (attrs, options) ->
      @client_performance = new ClientPerformance

      @workout_events = new WorkoutEventCollection([], user_id: options.user_id)

      @missed_events = new Backbone.VirtualCollection @workout_events,
        filter: (model) ->
          !model.get('is_completed') and
            model.get('ends_at_int') < moment().valueOf()
        comparator: 'ends_at_int'

      @todayEvents = new Backbone.VirtualCollection @workout_events,
        filter: (model) ->
          model.get('begins_at_int') > moment().valueOf() and
            model.get('begins_at_int') < moment().endOf('day').valueOf()
        comparator: 'begins_at_int'

      super

    fetch: ->
      @client_performance.fetch()
      @workout_events.fetch
        data:
          scope: 'all_with_clients'
          range_from: moment().subtract(7, 'day').toString()
          range_to: moment().toString()
        processData: true
        success: =>
          @set
            completed_today_count: @todayEvents.where(is_completed: true).length
            scheduled_today_count: @todayEvents.length

      super

    parse: (data) ->
      completed_today_count: @get('completed_today_count')
      scheduled_today_count: @get('scheduled_today_count')
      completed_count: data.events_completed_this_week_count
      scheduled_count: data.events_scheduled_this_week_count
      scheduled_tomorrow_count: data.events_scheduled_tomorrow_count
      scheduled_last_week_count: data.events_scheduled_last_week_count
