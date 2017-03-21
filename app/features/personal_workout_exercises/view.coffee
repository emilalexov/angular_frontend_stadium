define [
  './template'
  './list/view'
], (
  template
  ListView
) ->

  class PersonalWorkoutExercisesLayoutView extends Marionette.LayoutView

    template: template

    className: 'gc-workouts-exercises-view'

    behaviors:

      regioned:
        views: [
          region: 'workout_exercises_list'
          klass: ListView
        ]