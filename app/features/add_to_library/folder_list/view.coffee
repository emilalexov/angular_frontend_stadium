define [
  './item/view'
  './template'
], (
  FolderItemView
  template
) ->

  class FolderListView extends Marionette.CompositeView

    className: 'gc-add-modal-list-wrapper'

    template: template

    childView: FolderItemView

    childViewContainer: '.gc-add-modal-sub'

    childEvents:
      'folder:clicked': '_onFolderSelect'

    events:
      'click .parent a': '_parentSelected'

    templateHelpers: =>
      haveParent: !!@model.parent.get('parent_id')
      typeName: @options.type

    initialize: (data) ->
      @collection = @model.items

    _onFolderSelect: (view, _options) ->
      @trigger('folder:selected', view.model)

    _parentSelected: ->
      @trigger('folder:selected', @model.parent)
