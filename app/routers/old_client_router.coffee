define [
  'views/client/exercises/exercise_clientpage_view'
  'models/workout_exercise'
  'views/client/workouts/workout-clientpage-view'
  'models/global_workout'
  'models/personal_workout'
  'models/personal_program'
  'views/client/clientpage-calendar-day-view'
  'views/client/clientpage-calendar-week-view'
  'views/client/clientpage-calendar-month-view'
  'views/general/messages/messages-view'
], (
  ExerciseGlobalView
  WorkoutExercise
  WorkoutGlobalView
  GlobalWorkout
  PersonalWorkout
  PersonalProgram
  CalendarDayView
  CalendarWeekView
  CalendarMonthView
  MessagesView
) ->

  class Router extends Marionette.AppRouter

    appRoutes:

      'workout_exercises/:id(/)': 'workoutExercise'

      'calendar(/)': 'clientPageCalendarDay'
      'calendar/day/:day(/)': 'clientPageCalendarDay'
      'calendar/week/:week(/)': 'clientPageCalendarWeek'
      'calendar/month/:month(/)': 'clientPageCalendarMonth'

  class Controller extends Marionette.Controller

    workoutExercise: (id) ->
      @_assignedEntityShow('workout_exercises', id)

    _assignedEntityShow: (type, id) ->
      dataType = type.split('_')[1]
      eventName = 'clientpage:nav-click'
      elementId = "#gc-clientpage-nav-tab-#{dataType}"
      App.vent.trigger(eventName, elementId)

      klasses = {
        workout_exercises:
          model: WorkoutExercise
          view: ExerciseGlobalView
        personal_workouts:
          model: PersonalWorkout
          view: WorkoutGlobalView
        personal_programs:
          model: PersonalProgram
          view: WorkoutGlobalView
      }[type]

      model = new klasses.model(id: id)
      model.fetch().then =>
        view = new klasses.view
          model: model
          breadcrumbs: [{title: dataType}]
        @_userPageView().content.show(view)

    clientPageCalendarDay: (id) =>
      contentView = new CalendarDayView()
      @_userPageView().content.show contentView
      @changeNavTitle 'Calendar'
      App.vent.trigger 'clientpage:nav-click', '#gc-clientpage-nav-tab-c'

    clientPageCalendarWeek: (id) =>
      contentView = new CalendarWeekView()
      @_userPageView().content.show contentView
      @changeNavTitle 'Calendar'
      App.vent.trigger 'clientpage:nav-click', '#gc-clientpage-nav-tab-c'

    clientPageCalendarMonth: (id) =>
      contentView = new CalendarMonthView()
      @_userPageView().content.show contentView
      @changeNavTitle 'Calendar'
      App.vent.trigger 'clientpage:nav-click', '#gc-clientpage-nav-tab-c'

    changeNavTitle: (type) ->
      App.vent.trigger 'client:nav:change', type

    _userPageView: ->
      App.request('app:layouts:main')

  Router: Router
  Controller: Controller
  init: ->
    new Router
      controller: new Controller
