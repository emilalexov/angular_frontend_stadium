define [
  './template'
], (
  template
) ->

  class MissedWorkoutEventItemView extends Marionette.ItemView

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

          '.missed-workout-link':
            observe: 'workout_name'
            attributes: [
                name: 'href'
                observe: 'id'
                onGet: (id) -> "/#events/#{id}/results"
            ]
          'td.time':
            observe: 'begins_at'
            onGet: (value) ->
              moment.h.onlyTime(value)
