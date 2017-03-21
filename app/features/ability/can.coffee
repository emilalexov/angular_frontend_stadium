define [
  'cancan'
  'app/features/current_user/model'
  './namespaces/exercises'
  './namespaces/workout_templates'
  './namespaces/program_templates'
  './namespaces/personal_workouts'
  './namespaces/personal_programs'
], (
  cancan
  User
  exercises
  workout_templates
  program_templates
  personal_workouts
  personal_programs
) ->

  namespaces = [
    exercises
    workout_templates
    program_templates
    personal_workouts
    personal_programs
  ]

  cancan.configure User, (user) ->
    ctx = @
    namespaces.forEach (ability) ->
      ability.apply(ctx, [user])

  can = cancan.can

  ->
    user = App.request('current_user')
    can(user, arguments...)
