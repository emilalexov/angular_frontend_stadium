define [
  './concerns/nested_models'
  'features/personal_best/list/item/exercise_result_items_list/collection'
], (
  NestedModelsConcern
  ExerciseResultItemCollection
) ->

  class ExerciseResult extends Backbone.Model

    type: 'ExerciseResult'

    urlRoot: '/exercise_results'

    computed:
      name:
        depends: ['created_at']
        get: ([created_at]) ->
          moment(created_at).format('DD MMMM, YYYY')
        toJSON: false

    constructor: ->
      @_nestedModelsInit
        exercise_result_items: ExerciseResultItemCollection
      @exercise_result_items.exercise_result = @
      super

    initialize: ->
      @computedFields = new Backbone.ComputedFields(@)

    parse: (data) ->
      @_nestedModelsParseAll(data)
      data

  _.extend(ExerciseResult::, NestedModelsConcern)

  ExerciseResult
