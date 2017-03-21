define [
  './template'
  'features/personal_workout_exercises/view'
], (
  template
  WorkoutExercisesView
) ->

  class PersonalWorkoutOverviewView extends Marionette.LayoutView

    template: template

    className: 'gc-box-content'

    behaviors:
      regioned:
        views: [
            region: 'workout_exercises'
            klass: WorkoutExercisesView
            options: ->
              model: @model
              collection: @model.exercises
        ]

      stickit:
        bindings:
          '.description': 'description'
          '.note':
            observe: 'note'
            visible: true
            updateView: true
          'iframe':
            observe: 'video_url'
            visible: (value) ->
              !_.isEmpty(value)
            attributes: [
              observe: 'video_url'
              name: 'src'
            ]
          '.tabs':
            observe: ['video_url', 'description']
            visible: (attributes) ->
              _.any(attributes)

    ui:
      workoutTabsContent: '.gc-workout-tab-content'

    events:
      'click ul.gc-content-nav li a': '_changeTab'

    _changeTab: (ev) ->
      tabName = $(ev.currentTarget).data('content')
      @ui.workoutTabsContent.find('.tab-pane.active').removeClass('active')
      @ui.workoutTabsContent.find("[data-pane='#{tabName}']").addClass('active')