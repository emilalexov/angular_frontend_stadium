define [
  './template'
  'features/workout_exercises/view'
  'pages/personal_workouts/overview/overview/view'
], (
  template
  WorkoutExercisesView
  PersonalWorkoutOverview
) ->

  class ProgramWorkoutItemView extends Marionette.LayoutView

    template: template

    className: 'gc-program-workout-item personal'

    behaviors: ->

      mobile_only_features: true

      enter_results_for_new_workout_event:
        id: => @model.workout.id

      stickit:
        model: -> @model.workout
        bindings:
          ':el':
            attributes: [
                observe: 'id'
                name: 'data-id'
                onGet: -> @model.get('id')
            ]
          '.gc-workout-title > span':
            observe: 'name'
            events: ['blur']

      regioned:
        views: [
            region: 'workout_body'
            klass: PersonalWorkoutOverview
            options: ->
              model: @model.workout
              collection: @model.workout.exercises
        ]
