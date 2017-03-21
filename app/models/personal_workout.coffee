define [
  './concerns/nested_models'
  'collections/workout_exercises'
  'models/user'
], (
  NestedModelsConcern
  WorkoutExercises
  User
) ->

  class PersonalWorkout extends Backbone.Model

    type: 'PersonalWorkout'

    urlRoot: '/personal_workouts'

    constructor: ->
      @__defineGetter__ 'parent', @_getUser
      @_nestedModelsInit
        exercises: WorkoutExercises
      super

    parse: (data) ->
      @_nestedModelsParseAll(data)
      data

    person: ->
      person_id = @get('person_id')
      App.request('current_user').clients.get(person_id)

    _getUser: ->
      user = new User(id: @get('person_id'))
      user.fetch()
      user

  _.extend(PersonalWorkout::, NestedModelsConcern)

  PersonalWorkout
