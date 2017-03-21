define ->

  class AssignedWorkoutTemplatesToClientGroup extends Backbone.Collection

    model: (attrs, options) ->
      new (Backbone.Model.extend(type: 'WorkoutTemplate'))(attrs, options)

    url: ->
      "#{@clientGroup.url()}/assignments/workout_templates"

    constructor: (options) ->
      @clientGroup = options.clientGroup
      super
