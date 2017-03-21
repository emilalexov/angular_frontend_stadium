define ->

  class AssignedWorkoutTemplatesToClientGroup extends Backbone.Collection

    model: (attrs, options) ->
      new (Backbone.Model.extend(type: 'ProgramTemplate'))(attrs, options)

    url: ->
      "#{@clientGroup.url()}/assignments/program_templates"

    constructor: (options) ->
      @clientGroup = options.clientGroup
      super
