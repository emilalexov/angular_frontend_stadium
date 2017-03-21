define [
  './template'
  './list/view'
], (
  template
  ProgramPresetListView
) ->

  class ProgramPresetModalView extends Marionette.LayoutView

    template: template

    behaviors:

      regioned:
        views: [
            region: 'presets'
            klass: ProgramPresetListView
        ]

    ui:
      nextButton: 'a.next'

    events:
      'click a.prev': '_goBack'
      'click @ui.nextButton': '_loadPresets'
      'click a.skip': '_skip'

    onShow: ->
      @listenTo @views.presets.collection, 'add reset change:is_selected', =>
        if @views.presets.collection.where(is_selected: true).length
          @ui.nextButton.removeClass('disabled')
        else
          @ui.nextButton.addClass('disabled')

    _loadPresets:  ->
      models = @views.presets.collection.where(is_selected: true)

      promises = _.map models, (model) =>
        promise = model.import()
        promise.then(_.bind(@_parseNewEntities, @))
        promise

      $.when(promises...).then => @trigger('changeView', 'next')

    _parseNewEntities: (response) ->
      user = App.request('current_user')
      programs = user.program_templates
      models = programs.add(response, parse: true)
      @_addToFolders(models)
      _.each ['exercises', 'workout_templates'], (entities) =>
        user[entities].fetch()
          .then =>
            @_addToFolders(user[entities].models)

    _addToFolders: (models) ->
      user = App.request('current_user')
      _.each models, (model) ->
        folderId = model.get('folder_id')
        folder = user.folders.get(folderId)
        folder.items.add(model)

    _goBack: ->
      @trigger('changeView', 'prev')

    _skip: ->
      @trigger('changeView', 'next')
