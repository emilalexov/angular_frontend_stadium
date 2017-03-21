define [
  'models/exercise_property'
], (
  ExerciseProperty
) ->

  class ExerciseProperties extends Backbone.Collection

    type: 'ExerciseProperties'

    model: ExerciseProperty

    comparator: 'position'

    addProperties: (sourceModels, workout_exercise_id) ->
      dfds = _.map sourceModels, (sourceModel, key) =>
        defer = new $.Deferred
        attributes = _.extend({}, sourceModel.attributes, {
          workout_exercise_id: workout_exercise_id
          position: @length + key
        })
        @create attributes,
          wait: true
          success: -> defer.resolve()
          error: -> defer.reject()
        defer.promise()
      $.when(dfds...)

    initProperty: (workout_exercise_id, default_property = {}) ->
      model = new ExerciseProperty
        workout_exercise_id: workout_exercise_id
        position: @length
        personal_property: default_property
        personal_property_id: default_property.id
        value: null
      @add(model)

    getZeroedAttributes: ->
      @map (model) ->
        attrs = model.toJSON()
        property_units = model.personal_property.property_units.toJSON()
        attrs.value = attrs.value2 = 0
        attrs.personal_property.property_units = property_units
        attrs

    zeroValues: ->
      @each((model) -> model.set(value: 0))
