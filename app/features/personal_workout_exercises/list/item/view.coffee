define [
  './template'
  'features/exercise_properties/list_readable/view'
], (
  template
  ExercisePropertiesListView
) ->

  class PersonalWorkoutExercisesItemView extends Marionette.LayoutView

    template: template

    tagName: 'li'

    className: 'gc-workout-exercise-item'

    behaviors:

      regioned:
        views: [
          klass: ExercisePropertiesListView
          region: 'exercise_properties'
          options: ->
            collection: @model.exercise_properties
        ]

      stickit:
        bindings:
          '.gc-workout-exercise-circle-cell':
            attributes: [
                name: 'data-order_position'
                observe: 'order_position'
            ]
          '.gc-workout-exercise-circle, .line-top, .line-bottom':
            attributes: [
                name: 'style'
                observe: 'color'
                onGet: (value) ->
                  "background-color: #{value}"
            ]
          '.gc-workout-exercise-circle':
            observe: 'order_name'
            events: ['blur']
            getVal: ($el) ->
              $el.text().toUpperCase()
            attributes: [
                name: 'tabindex'
                observe: 'position'
            ]
          '.gc-workout-exercise-note': 'note'
          '.gc-workout-exercise-name':
            observe: 'name'
            attributes: [
                name: 'href'
                observe: 'id'
                onGet: (value) ->
                  "#workout_exercises/#{value}"
            ]
