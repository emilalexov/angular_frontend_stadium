define [
  'collections/user_collection'
  'models/user'
  'models/client_group'
  'models/exercise'
  'models/workout_template'
  'models/program_template'
  'models/personal_program'
  'models/personal_property'
  'models/personal_workout'
  'models/folder'
], (
  UserCollection
  User
  ClientGroup
  Exercise
  WorkoutTemplate
  ProgramTemplate
  PersonalProgram
  PersonalProperty
  PersonalWorkout
  Folder
)->

  (user) ->

    collections =
      pros: User
      clients: User
      client_groups: ClientGroup
      exercises: Exercise
      personal_properties: PersonalProperty
      workout_exercises: Exercise
      personal_workouts: PersonalWorkout
      personal_programs: PersonalProgram
      workout_templates: WorkoutTemplate
      program_templates: ProgramTemplate
      folders: Folder
      notifications: Backbone.Model
      library: Folder
      personal_exercises: Exercise
      # workout_events: Backbone.Model

    if not user.get('is_pro')
      toExclude = [
        'exercises'
        'client_groups'
        'folders'
        'personal_properties'
        'library'
      ]
      for key in toExclude
        delete collections[key]

    _.map collections, (model, item) ->
      collection = new UserCollection [],
        model: model
        user: user
        type: item
      user.__defineGetter__(item, -> collection)
      collection.fetch()
