define [
  './concerns/nested_models'
  './workout_template'
  './personal_workout'
  './program_template'
  './personal_program'
], (
  NestedModelsConcern
  WorkoutTemplate
  PersonalWorkout
  ProgramTemplate
  PersonalProgram
) ->

  class ProgramWorkout extends Backbone.Model

    type: 'ProgramWorkout'

    urlRoot: '/program_workouts/'

    computed: ->
      name:
        depends: ['workout_id']
        get: -> @workout?.get?('name')
        toJSON: false

    constructor: ->
      @_nestedModelsInit
        program:
          polymorphicKey: 'program_type'
          polymorphicModels:
            ProgramTemplate: ProgramTemplate
            PersonalProgram: PersonalProgram
        workout:
          polymorphicKey: 'workout_type'
          polymorphicModels:
            WorkoutTemplate: WorkoutTemplate
            PersonalWorkout: PersonalWorkout
      super

    initialize: ->
      @computedFields = new Backbone.ComputedFields(@)

    parse: (data) ->
      @_nestedModelsParseAll(data)
      data

    duplicate: ->
      defer = new $.Deferred
      if @get('workout_type') is 'PersonalWorkout'
        options = App.request 'ajax:options:create',
          url: "#{@url()}/duplicate"
          data: null

        sync = (@sync || Backbone.sync)
        request = sync.call(@, null, @, options)
        request.then (response) ->
          newProgramWorkout = new ProgramWorkout(response, parse: true)
          defer.resolve(newProgramWorkout, response, options)
      else
        newProgramWorkout = new ProgramWorkout
          program_id: @get('program_id')
          program_type: @get('program_type')
          workout_template_id: @get('workout_id')
          position: @collection?.length + 1
          week_id: @get('week_id')

        newProgramWorkout.save({}, wait: true).then (response) ->
          defer.resolve(newProgramWorkout, response)
      defer.promise()

  _.extend(ProgramWorkout::, NestedModelsConcern)

  ProgramWorkout
