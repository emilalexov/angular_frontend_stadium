define [
  './template'
], (
  template
) ->

  class EmptyExerciseResults extends Marionette.ItemView

    template: template

    className: 'no-exercise-results'

    behaviors: ->

      stickit:
        bindings:
          '.full-name':
            observe: 'name'
            onGet: (value) ->
              value or 'User'
