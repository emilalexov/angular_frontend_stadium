define [
  './concerns/nested_models'
  './personal_workout'
  './client_group'
  'collections/workout_exercises'
], (
  NestedModelsConcern
  PersonalWorkout
  ClientGroup
  WorkoutExercises
) ->

  class WorkoutTemplate extends Backbone.Model

    type: 'WorkoutTemplate'

    urlRoot: '/workout_templates/'

    defaults:
      is_visible: true

    validation:
      name:
        required: true

    constructor: ->
      Groups = Backbone.Collection.extend(model: ClientGroup)
      @_nestedModelsInit
        exercises: WorkoutExercises
        group_assignments: Groups
        assignees: Backbone.Collection
      super

    initialize: (_options) ->
      @__defineGetter__ 'parent', @_getFolder
      @__defineGetter__ 'folder', @_getFolder

    parse: (data) ->
      data.assignees &&
        @_parseAssignees(data.assignees) &&
        delete data.assignees
      @_nestedModelsParseAll(data)
      data

    assignTo: (user) ->
      assignment = new PersonalWorkout
        person_id: user.id
        workout_template_id: @id

      assignment.save()

    _getFolder: ->
      user = App.request('current_user')
      collection = user.folders
      collection.get(@get('folder_id'))

    _parseAssignees: (assignees) ->
      items = _.map assignees, (item) =>
        collection = App.request('current_user').personal_workouts
        personalWorkout = collection.get(item.id)
        unless personalWorkout
          item.workout_template_id = @get('id')
          personalWorkout = new PersonalWorkout(item)
        personalWorkout
      @assignees.reset(items)

  _.extend(WorkoutTemplate::, NestedModelsConcern)

  WorkoutTemplate
