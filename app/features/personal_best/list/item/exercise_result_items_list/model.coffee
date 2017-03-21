define [
  'models/concerns/nested_models'
  'models/exercise_property'
  'models/concerns/unit_convertion'
], (
  NestedModelsConcern
  ExerciseProperty
  unit_convertion
) ->

  class ExerciseResultItem extends Backbone.Model

    type: 'ExerciseResultItem'

    urlRoot: -> @collection.url()

    computed: ->
      value_converted:
        depends: ['value']
        get: _.bind(unit_convertion.get, @exercise_property, 'value')
        set: _.bind(unit_convertion.set, @exercise_property, 'value')
        toJSON: false

    constructor: ->
      @_nestedModelsInit
        exercise_property: ExerciseProperty
      super

    initialize: ->
      @computedFields = new Backbone.ComputedFields(@)

    parse: (data) ->
      @_nestedModelsParseAll(data)
      data

  _.extend(ExerciseResultItem::, NestedModelsConcern)

  ExerciseResultItem