define [
  './concerns/nested_models'
  './personal_workout'
  'collections/program_workouts'
  'collections/program_weeks'
  'models/user'
], (
  NestedModelsConcern
  PersonalWorkout
  ProgramWorkouts
  ProgramWeeks
  User
) ->

  class PersonalProgram extends Backbone.Model

    type: 'PersonalProgram'

    urlRoot: '/personal_programs'

    constructor: ->
      @__defineGetter__ 'parent', @_getUser
      @_nestedModelsInit
        weeks: ProgramWeeks
        workouts: ProgramWorkouts
      @weeks.program = @
      @workouts.program = @
      super

    parse: (data) ->
      @_nestedModelsParseAll(data)
      data

    _getUser: ->
      user = new User(id: @get('person_id'))
      user.fetch()
      user

  _.extend(PersonalProgram::, NestedModelsConcern)

  PersonalProgram
