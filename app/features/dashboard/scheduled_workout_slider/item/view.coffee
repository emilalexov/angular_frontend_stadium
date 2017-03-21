define [
  './template'
], (
  template
) ->

  class ScheduledWorkoutSliderItemView extends Marionette.ItemView

    template: template

    className: 'item'

    triggers:
      'click .owl-prev': 'owl:prev'
      'click .owl-next': 'owl:next'

    behaviors: ->
      stickit:
        bindings:
          '.workout-link':
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
