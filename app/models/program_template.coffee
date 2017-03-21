define [
  './concerns/nested_models'
  './personal_program'
  './personal_workout'
  './client_group'
  'collections/program_workouts'
  'collections/program_weeks'
], (
  NestedModelsConcern
  PersonalProgram
  PersonalWorkout
  ClientGroup
  ProgramWorkouts
  ProgramWeeks
) ->

  class ProgramTemplate extends Backbone.Model

    type: 'ProgramTemplate'

    urlRoot: '/program_templates/'

    validation:
      name:
        required: true

    initialize: (_options) ->
      @__defineGetter__ 'parent', @_getFolder
      @__defineGetter__ 'folder', @_getFolder

    constructor: ->
      Groups = Backbone.Collection.extend(model: ClientGroup)
      @_nestedModelsInit
        weeks: ProgramWeeks
        workouts: ProgramWorkouts
        group_assignments: Groups
        assignees: Backbone.Collection
      @weeks.program = @
      @workouts.program = @
      super

    parse: (data) ->
      @_parseAssignees(data.assignees) && delete data.assignees
      @_nestedModelsParseAll(data)
      data

    assignTo: (user) ->
      assignment = new PersonalProgram
        person_id: user.id
        program_template_id: @id
      assignment.save()

    _getFolder: ->
      user = App.request('current_user')
      collection = user.folders
      collection.get(@get('folder_id'))

    _parseAssignees: (assignees) ->
      items = _.map assignees, (item) =>
        collection = App.request('current_user').personal_programs
        personalProgram = collection.get(item.id)
        unless personalProgram
          item.program_template_id = @get('id')
          personalProgram = new PersonalProgram(item)
        personalProgram
      @assignees.reset(items)

  _.extend(ProgramTemplate::, NestedModelsConcern)

  ProgramTemplate
