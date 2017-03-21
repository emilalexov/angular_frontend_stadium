define [
  './template'
], (
  template
) ->

  class EmptyView extends Marionette.ItemView

    template: template

    templateHelpers: ->
      resource: @resource
      resources: @resources

    behaviors: ->

      stickit:
        bindings:
          '.gc-exercises-assign-add':
            attributes: [
                name: 'href'
                observe: 'id'
                onGet: (_value) ->
                  user = App.request('current_user')
                  rootFolder = user.library.first()
                  name = @_templatesFolderName()
                  folder = rootFolder.nestedFolders.findWhere({name: name})
                  "/##{@resource}_templates_folder/#{folder.id}"
            ]

    initialize: ->
      name = _.chain(@options.type)
        .humanize()
        .words()
        .last()
        .value()
      @resource = name
      @resources = _.pluralize(name)

    _templatesFolderName: ->
      {
        PersonalProgram: 'Program Templates'
        PersonalWorkout: 'Workout Templates'
      }[@options.type]
