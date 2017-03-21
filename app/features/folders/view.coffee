define [
  './entity_list/view'
  './add_entity_modal/view'
  './add_folder_modal/view'
  './duplicate_modal/view'
  './template'
], (
  EntityListView
  AddEntityModalView
  AddFolderModalView
  DuplicateModalView
  template
) ->

  class FolderListView extends Marionette.LayoutView

    key: 'FolderListView'

    template: template

    regions:
      collectionRegion: 'region[data-name="collection"]'
      modalRegion: '#gc-modal-region'

    ui:
      liveSearch: '.live-search'
      mainCheckbox: '.gc-content-nav-checkall input'
      collectionRegion: 'region[data-name="collection"]'
      folderAddButton: '.gc-show-add-exercise-folder-modal'
      folderEditButton: '.gc-show-edit-folder-modal'
      itemAddButton: '.gc-show-add-exercise-modal'
      itemDuplicateButton: '.gc-show-duplicate-modal'
      itemDeleteButton: '[data-action="remove"]'
      actionModal: '#gc-modal-region'
      itemCheckBox: '.gc-exercises-chb input'

    events:
      'click @ui.mainCheckbox': 'toggleCheck'
      'click @ui.folderAddButton': '_showAddFolderModal'
      'click @ui.folderEditButton': '_showEditFolderModal'
      'click @ui.itemAddButton': '_showAddEntityModal'
      'click @ui.itemDuplicateButton': '_showDuplicateModal'
      'click @ui.itemDeleteButton': '_showDestroySelectedModal'
      'click @ui.itemCheckBox': '_toggleActionsBtnVisibility'

    behaviors: ->

      navigate_back: true

      breadcrumbs: true

      auto_complete:
        onItemAdd: (id, $item) ->
          Backbone.history.navigate("##{@typeName}/#{id}", trigger: true)
        collection: =>
          App.request('current_user')[@typeName]
        serealizeFn: (item) ->
          folder: item.folder?.name
          id: item.get('id')
          name: item.get('name')
          label: item.get('name')

      stickit:
        bindings:
          '.gc-show-edit-folder-modal':
            observe: 'id'
            visible: (value) ->
              user = App.request('current_user')
              rootFolder = user.library.first()
              ids = rootFolder.items.pluck('id')
              !_.contains(ids.concat(rootFolder.id), value)

    templateHelpers: ->
      type: @typeName
      singularName: @singularName

    initialize: (data) ->
      @collection = data.items
      @typeName = data.type
      @singularName = _.chain(@typeName).humanize().singularize().value()

    onShow: ->
      @_showEntityList()

    _toggleActionsBtnVisibility: =>
      if $('.gc-exercises-chb input[type=checkbox]:checked').length > 0
        $.each [@ui.itemDuplicateButton, @ui.itemDeleteButton], (i, el) ->
          el.removeClass('disp-none')
      else
        $.each [@ui.itemDuplicateButton, @ui.itemDeleteButton], (i, el) ->
          el.addClass('disp-none')

    _showEntityList: ->
      @listView = new EntityListView
        collection: @collection
        type: @typeName
      @getRegion('collectionRegion').show(@listView)

      @listenTo(@listView, 'item:clicked', @_updateSelectedItems)

    toggleCheck: (ev) =>
      checked = @ui.mainCheckbox.is(':checked')
      @ui.collectionRegion.find('input[type=checkbox]').prop('checked', checked)
      @_toggleActionsBtnVisibility()

    _updateSelectedItems: ->
      for check in @ui.collectionRegion.find('input[type=checkbox]')
        if needToggle?
          if needToggle != $(check).is(':checked')
            @ui.mainCheckbox.prop 'checked', false
            return
        needToggle = $(check).is(':checked')
      if needToggle
        @ui.mainCheckbox.prop 'checked', true

    _showDestroySelectedModal: (ev) =>
      App.request 'modal:confirm',
        title: 'Delete item(s)'
        content: 'Are you sure you want to delete selected items?'
        confirmBtn: 'Delete'
        confirmCallBack: @_onDestroyConfirm

    _onDestroyConfirm: =>
      checked = @ui.collectionRegion.find('input[type=checkbox]:checked')
      ids = checked.map( (_index, el) -> $(el).closest('li').data('id') )
      @listView.trigger('items:delete', ids, @model.get('id'))

    _showAddEntityModal: (ev) ->
      view = new AddEntityModalView
        folder: @model
        type: @typeName

      @getRegion('modalRegion').show(view)
      @ui.actionModal.modal('show')

    _showAddFolderModal: (ev) ->
      view = new AddFolderModalView
        parent: @model
        type: @typeName

      @getRegion('modalRegion').show(view)
      @ui.actionModal.modal('show')

    _showEditFolderModal: ->
      App.request 'modal:prompt',
        title: 'Edit Folder Name'
        confirmBtn: 'Rename'
        cancelCallBack: -> # nothing
        confirmCallBack: (name) => @model.patch(name: name)

    _showDuplicateModal: (ev) =>
      view = new DuplicateModalView
        collection: @model.nestedFolders
        type: @typeName

      @listenToOnce(view, 'items:duplicate', @_duplicateEntity)

      @modalRegion.show(view)
      @ui.actionModal.modal('show')

    _duplicateEntity: (foldersIds) ->
      checked = @ui.collectionRegion.find('input[type=checkbox]:checked')
      ids = checked.map( (_index, el) -> $(el).data('id') )

      if ids.length and foldersIds.length
        @collection.duplicate(
          ids: ids.toArray()
          foldersIds: foldersIds.toArray()
        ).then(@_onDuplicate)
      else
        App.request('messenger:explain', 'item.not_selected')

    _onDuplicate: (response) =>
      @ui.actionModal.modal('hide')
      App.request('messenger:explain', 'item.duplicated')
