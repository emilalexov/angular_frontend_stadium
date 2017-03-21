define [
  'pages/base/page'
  './template'
  'features/dashboard/client_model'
  'features/dashboard/trainer_info/view'
  'features/dashboard/completion_ring/view'
  'features/dashboard/scheduled_workout_slider/view'
  'features/dashboard/info_tables/view'
  'features/dashboard/workout_events/view'
], (
  BasePage
  template
  ClientDashboardModel
  TrainerInfoView
  CompletionRingView
  ScheduledWorkoutSliderView
  InfoTablesView
  WorkoutEventsTableView
) ->

  class Page extends BasePage

    template: template

    regions:
      page_content: 'region[data-name="page_content"]'

    ui: calendar: '#workout-calendar'

    behaviors: ->

      regioned:
        views: [
            region: 'trainer_info'
            klass: TrainerInfoView
            options: ->
              user = App.request('current_user')
              model: user.pros.findWhere
                is_confirmed: true
                live: true
          ,
            region: 'completion_ring'
            klass: CompletionRingView
            options: ->
              dataModel: @model.get('data.model')
              listen: ['completed_count', 'scheduled_count']
              description: 'Workouts completed this week'
              className: 'gc-workout-indicator client'
          ,
            region: 'scheduled_workout_slider'
            klass: ScheduledWorkoutSliderView
            options: ->
              collection: @model.get('data.model').scheduled_workouts
          ,
            region: 'info_tables'
            klass: InfoTablesView
            options: ->
              model = @model.get('data.model')
              tables: [
                  region: 'scheduled_workouts'
                  name: 'Workouts scheduled this week'
                  klass: WorkoutEventsTableView
                  options: ->
                    collection: model.scheduled_workouts
                    withStatus: false
                ,
                  region: 'completed_workouts'
                  name: 'Workouts completed this week'
                  klass: WorkoutEventsTableView
                  options: ->
                    collection: model.past_workouts
                    withStatus: true
              ]
        ]

    initModel: ->
      new ClientDashboardModel({}, user_id: App.request('current_user_id'))

    initViews: ->
      root: ->
