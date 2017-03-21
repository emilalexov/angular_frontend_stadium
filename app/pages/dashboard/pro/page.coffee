define [
  'pages/base/page'
  './template'
  'features/dashboard/pro_model'
  'features/dashboard/completion_ring/view'
  'features/dashboard/info_tables/view'
  'features/dashboard/client_performance/view'
  'features/dashboard/missed_workout_events/view'
  'features/dashboard/workout_events_this_week/view'
], (
  BasePage
  template
  ProDashboardModel
  CompletionRingView
  InfoTablesView
  ClientPerformanceCollectionView
  MissedWorkoutEventsView
  WorkoutEventsThisWeekView
) ->

  class Page extends BasePage

    template: template

    regions:
      page_content: 'region[data-name="page_content"]'

    templateHelpers: ->
      user = App.request('current_user')
      exercises_folder_id = user.getRootFolderFor('Exercises').id
      workouts_folder_id = user.getRootFolderFor('Workout Templates').id
      programs_folder_id = user.getRootFolderFor('Program Templates').id

      exercise_link: "/#exercises_folder/#{exercises_folder_id}"
      workout_link: "/#workout_templates_folder/#{workouts_folder_id}"
      program_link: "/#program_templates_folder/#{programs_folder_id}"

    behaviors: ->
      stickit:
        model: -> @model.get('data.model')
        bindings:
          '.workout-amount:first .counter': 'scheduled_tomorrow_count'
          '.workout-amount:last .counter': 'scheduled_count'
          '.workout-amount:last .counter-progress':
            observe: 'scheduled_last_week_count'
            classes:
              positive:
                observe: ['scheduled_last_week_count', 'scheduled_count']
                onGet: (values) ->
                  values[0] < values[1]
              negative:
                observe: ['scheduled_last_week_count', 'scheduled_count']
                onGet: (values) ->
                  values[0] > values[1]

      regioned:
        views: [
            region: 'completion_ring_today'
            klass: CompletionRingView
            options: ->
              dataModel: @model.get('data.model')
              customName: 'completed'
              listen: ['completed_today_count', 'scheduled_today_count']
              description: 'Workouts remaining today'
              className: 'gc-workout-indicator'
          ,
            region: 'completion_ring_this_week'
            klass: CompletionRingView
            options: ->
              dataModel: @model.get('data.model')
              customName: 'completed'
              listen: ['completed_count', 'scheduled_count']
              description: 'Workouts completed by clients this week'
              className: 'gc-workout-indicator'
          ,
            region: 'info_tables'
            klass: InfoTablesView
            options: ->
              model = @model.get('data.model')
              tables: [
                  region: 'scheduled_workouts'
                  name: 'Workouts this week'
                  klass: WorkoutEventsThisWeekView
                  options: ->
                    events: model.workout_events
                ,
                  region: 'client_performance'
                  name: 'Client Performance'
                  klass: ClientPerformanceCollectionView
                  options: ->
                    collection: model.client_performance
                ,
                  region: 'missed_workout_events'
                  name: 'Missed workouts'
                  klass: MissedWorkoutEventsView
                  options: ->
                    collection: model.missed_events
              ]
        ]

    initModel: ->
      new ProDashboardModel({}, user_id: App.request('current_user_id'))

    initViews: ->
      root: ->
