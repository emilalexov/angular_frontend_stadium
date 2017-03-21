define [
  './list/view'
  './template'
  'collections/user_collection'
  'models/personal_program'
  'models/personal_workout'
  'models/program_template'
  'models/workout_template'
], (
  AssignedTemplateListView
  template
  UserCollection
  PersonalProgram
  PersonalWorkout
  ProgramTemplate
  WorkoutTemplate
) ->

  class AssignedTemplatesLayoutView extends Marionette.LayoutView

    key: 'AssignedTemplatesLayoutView'

    template: template

    className: 'gc-exercises-assign'

    behaviors: ->

      stickit:
        bindings:
          'input.gc-exercises-assign-input':
            attributes: [
                name: 'placeholder'
                observe: 'name'
                onGet: (value) ->
                  currentUser = App.request('current_user').user_settings
                  title = _.singularize(currentUser.get('clients_title'))
                    .toLowerCase()
                  templateName = @_getTemplate(@options.viewType)
                  name = _.humanize(templateName)
                  "Search & assign #{name} to this #{title}"
            ]

      regioned:
        views: [
            region: 'list'
            klass: AssignedTemplateListView
            options: ->
              Model = @_getPersonalModelClass(@options.viewType)
              collection: new UserCollection [],
                user: @model
                model: Model
                type: @options.viewType
        ]

      auto_complete:
        defaultOption:
          name: 'Assign new one'

        onItemAdd: (id, $item, selectize) ->
          intId = parseInt(id, 10)
          @_assign(id) if intId
          @_assignNewOne() unless intId

          selectize.clear()
          selectize.close()

        collection: =>
          type = @_getTemplate(@options.viewType)
          App.request('current_user')[type]

        serealizeFn: (item) ->
          folder: item.folder?.get('name')
          id: item.get('id')
          name: item.get('name')
          label: item.get('name')
          sort_id: "~-2-#{_.underscore(item.get('name'))}"

    initialize: ->
      @listenTo(@, 'nav:assign', @_assignNewOne)

    _getTemplate: (personalName) ->
      {
        personal_workouts: 'workout_templates'
        personal_programs: 'program_templates'
      }[personalName]

    _getTemplateModelClass: (personalName) ->
      {
        personal_workouts: WorkoutTemplate
        personal_programs: ProgramTemplate
      }[personalName]

    _getPersonalModelClass: (personalName) ->
      {
        personal_workouts: PersonalWorkout
        personal_programs: PersonalProgram
      }[personalName]

    _assign: (id) ->
      type = @_getTemplate(@options.viewType)
      templates = App.request('current_user')[type]
      template = templates.get(id)

      template.assignTo(@model)
        .then(_.bind(@_assignCallback, @, template))

    _assignNewOne: ->
      type = _.singularize @options.viewType.split('_')[1]
      username = @model.user_profile.get('full_name')
      App.request 'modal:prompt',
        title: "Create new #{type} for #{username}"
        confirmBtn: 'Create'
        confirmCallBack: _.bind(@_assignNewOneConfirmCallBack, @)
        cancelCallBack: -> # nothing

    _assignNewOneConfirmCallBack: (name) ->
      TemplateModel = @_getTemplateModelClass(@options.viewType)
      template = new TemplateModel
        name: name || 'New'
        is_visible: false
      template.save().then =>
        template.assignTo(@model)
          .then(_.bind(@_assignCallback, @, template))
          .then -> template.destroy()

    _assignCallback:  (template, response) ->
      Model = @_getPersonalModelClass(@options.viewType)
      assignment = new Model(response)
      @views.list.collection.add(assignment)
