define [
  './template'
], (
  template
) ->

  class ItemView extends Marionette.ItemView

    tagName: 'tr'

    template: template

    templateHelpers: ->
      withStatus: @options.withStatus

    behaviors: ->
      stickit:
        bindings:
          '.performed-workout-link':
            observe: 'workout_name'
            attributes: [
                name: 'href'
                observe: 'id'
                onGet: (id) -> "/#events/#{id}/results"
            ]
          '.date':
            observe: 'begins_at'
            onGet: (value) ->
              moment.h.onlyDate(value)
          '.time':
            observe: 'begins_at'
            onGet: (value) ->
              moment.h.onlyTime(value)
          'i.workout-status':
            classes:
              completed: 'is_completed',
              incomplete:
                observe: 'is_completed'
                onGet: (bool) -> !bool
