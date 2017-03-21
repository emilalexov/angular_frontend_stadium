define [
  './template'
], (
  template
) ->

  class ClientPerformanceItemView extends Marionette.ItemView

    template: template

    tagName: 'tr'

    behaviors: ->
      getPercent = (value) ->
        percent = 100 * value
        number = Number(Math.round(percent + 'e2') + 'e-2') or 0
        "#{number}%"

      stickit:
        bindings:
          '.user-link': 'full_name'
          'a':
            attributes: [
                name: 'href'
                observe: 'id'
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
                observe: 'avatar_thumb_url'
            ]
          'td.last-week':
            observe: 'last_week_performance'
            onGet: getPercent
          '.dynamic-counter':
            observe: 'this_week_performance'
            onGet: getPercent
            classes:
              positive:
                observe: ['last_week_performance', 'this_week_performance']
                onGet: (values) ->
                  values[1] > values[0]
              negative:
                observe: ['last_week_performance', 'this_week_performance']
                onGet: (values) ->
                  values[1] < values[0]
