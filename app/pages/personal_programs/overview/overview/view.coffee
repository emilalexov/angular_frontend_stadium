define [
  './template'
  'features/program_weeks/list_readable/view'
  'features/program_workouts/list_readable/view'
  './empty/view'
  'models/program_workout'
], (
  template
  ProgramWeeksListView
  ProgramWorkoutsListView
  EmptyView
  ProgramWorkout
) ->

  class View extends Marionette.LayoutView

    template: template

    className: 'gc-box-content'

    behaviors:
      regioned:
        views: [
            region: 'program_weeks'
            klass: ProgramWeeksListView
            options: ->
              collection: @model.weeks
          ,
            region: 'program_workouts'
            klass: ProgramWorkoutsListView
            options: ->
              collection = new Backbone.VirtualCollection @model.workouts,
                filter: (model) -> !model.get('week_id')
                comparator: 'position'
              model: @model
              collection: collection
          ,
            region: 'program_empty'
            klass: EmptyView
            options: ->
              weeks: @model.weeks
              workouts: @model.workouts
        ]

      stickit:
        bindings:
          '.description': 'description'
          '.note': 'note'