define [
  './template'
], (
  template
) ->

  class ItemView extends Marionette.ItemView

    template: template

    tagName: 'li'

    className: 'row'

    behaviors: ->

      stickit:
        bindings:
          '.name': 'name'
          '.gc-exercises-link-workouts':
            attributes: [
                name: 'href'
                observe: 'id'
                onGet: (value) ->
                  "#users/#{@options.user.id}/exercises/#{value}"
            ]
