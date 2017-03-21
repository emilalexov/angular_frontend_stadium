define [
  './concerns/avatar_background_color'
  './concerns/nested_models'
  'collections/workout_event_exercises'
  'features/event_results/comments/collection'
], (
  AvatarBackgroundColor
  NestedModelsConcern
  WorkoutEventExercises
  Comments
) ->

  class WorkoutEvent extends Backbone.Model

    type: 'WorkoutEvent'

    url: -> "/workout_events/#{@id}/full"

    computed: ->
      begins_at_int:
        depends: ['begins_at']
        get: (attrs) ->
          moment(attrs.begins_at).valueOf()
        toJSON: false
      ends_at_int:
        depends: ['ends_at', 'begins_at']
        get: (attrs) ->
          if attrs.ends_at
            moment(attrs.ends_at)
          else
            moment(attrs.begins_at).add(1, 'day')
        toJSON: false

    constructor: ->
      @_nestedModelsInit
        exercises: WorkoutEventExercises
        comments: Comments
      @comments.workout_event = @
      super

    initialize: ->
      super
      @computedFields = new Backbone.ComputedFields(@)
      @_initBgColor('person_id')

    parse: (data) ->
      @_nestedModelsParseAll(data)
      data

    finish: ->
      @save({is_completed: true},
        wait: true
        url: "/workout_events/#{@id}"
      )

  _.extend(WorkoutEvent::, NestedModelsConcern, AvatarBackgroundColor)

  WorkoutEvent