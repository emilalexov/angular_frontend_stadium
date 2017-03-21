define [
  './folder_list/view'
  './template'
], (
  FolderListView
  template
) ->
  class ModalAddToLibraryView extends Marionette.LayoutView

    template: template

    behaviors:

      form_validation: true

    ui:
      form: 'form'

    regions:
      library: 'region[data-name="library"]'

    events:
      'submit @ui.form': '_onSubmit'

    initialize: ->
      user = App.request('current_user')
      @options.type ||= _.chain(@options.model.type)
        .underscored()
        .pluralize()
        .value()
      initialFolder = user.getRootFolderFor(@options.type)

      @viewData = new Backbone.Model
      @viewData.set
        folder: initialFolder
        folderList: @_getFolderListView(initialFolder)

      @listenTo(@viewData, 'change:folder', @_onFolderChange)
      @listenTo(@viewData, 'change:folderList', @_showFolderList)

      @

    templateHelpers: ->
      type: @options.type
      typeNameSingle: _.singularize(@options.type)

    onShow: ->
      @getRegion('library').show(@viewData.get('folderList'))

    _showFolderList: (_model, view, _options) ->
      @getRegion('library').show(view)

    _onFolderChange: (_model, folder, _options) ->
      view = @viewData.get('folderList')
      @stopListening(view)
      newView = @_getFolderListView(folder)
      @viewData.set(folderList: newView)

    _getFolderListView: (folder) ->
      folderList = new FolderListView
        type: @options.type
        model: folder

      @listenTo(folderList, 'folder:selected', @_onFolderSelect)
      folderList

    _onFolderSelect: (folder) ->
      @viewData.set(folder: folder)

    _onSubmit: (ev) ->
      folder = @viewData.get('folder')
      folder.items.duplicate(
        ids: [@model.id]
        foldersIds: [folder.id]
      ).then =>
        @$el.parent().modal('hide')
        App.request 'messenger:explain', 'item.added_to_library',
          type: @model.type
