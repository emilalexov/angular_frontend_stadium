define [
  './model'
], (
  ExerciseResultItem
) ->

  class ExerciseResultItemCollection extends Backbone.Collection

    model: ExerciseResultItem

    url: ->
      "/exercise_results/#{@exercise_result.id}/items"
