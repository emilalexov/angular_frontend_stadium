define [
  './concerns/nested_models'
  'collections/exercise_properties'
], (
  NestedModelsConcern
  ExerciseProperties
) ->

  class WorkoutsExercise extends Backbone.Model

    type: 'WorkoutsExercise'

    urlRoot: '/workout_exercises'

    validation:

      name:
        required: true

      workout_id:
        required: true

      exercise_id:
        required: true

    constructor: ->
      @_nestedModelsInit
        exercise_properties: ExerciseProperties
      super

    initialize: ->
      @listenTo(@, 'change:order_name', @_syncOrderName)
      @_syncOrderName()
      @

    changedAttributes: ->
      result = super
      if _.isObject(result)
        result = _.omit(result, [
          'order_number'
          'order_letter'
        ]...)
      if _.isEmpty(result) then false else result

    parse: (data) ->
      @_nestedModelsParseAll(data)
      data

    _syncOrderName: ->
      value = "#{@get('order_name') || ''}"
      re = /^([a-z]{1,2})(\d{1,2})$/i
      match = value.match(re)
      @set
        order_letter: match?[1] || '~'
        order_number: match?[2]

  _.extend(WorkoutsExercise::, NestedModelsConcern)

  WorkoutsExercise
