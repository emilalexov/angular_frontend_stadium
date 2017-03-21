define [
  'models/exercise_result'
], (
  ExerciseResult
) ->

  class PersonalBestCollection extends Backbone.Collection

    model: ExerciseResult

    url: ->
      "/exercises/#{@exerciseId}/personal_best/#{@userId}"

    initialize: (models, options) ->
      @userId = options?.userId
      @exerciseId = options?.exerciseId
