define [
  './template'
], (
  template
) ->

  class WorkoutEventItemView extends Marionette.ItemView

    template: template

    tagName: 'tr'

    behaviors: ->

      stickit:
        bindings:
          '.user-link': 'person_name'
          'a.user-avatar, a.user-link':
            attributes: [
                name: 'href'
                observe: 'person_id'
                onGet: (id) -> "/#users/#{id}"
            ]
          '.user-avatar':
            attributes: [
                name: 'style'
                observe: 'avatar_background_color'
                onGet: (value) -> "background-color: #{value}"
            ]
          '.user-avatar img':
            attributes: [
                name: 'src'
                observe: 'person_avatar'
            ]

          '.performed-workout-link':
            observe: 'workout_name'
            attributes: [
                name: 'href'
                observe: 'id'
                onGet: (id) -> "/#events/#{id}/results"
            ]
            classes:
              missed:
                observe: 'ends_at_int'
                onGet: (value) ->
                  value < moment().valueOf()
          'td.time':
            observe: 'begins_at'
            onGet: (value) ->
              moment.h.onlyTime(value)
