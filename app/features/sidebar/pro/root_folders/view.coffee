define [
  './template'
  '../entity_templates/view'
  '../entity_templates/item/view'
], (
  template
  TemplateCollectionView
  TemplateItemView
)->

  class RootFolderView extends Marionette.CompositeView

    template: template

    className: 'gc-sidebar-cat'

    ui:
      sidebarSubs: '.gc-sidebar-sub'

    getChildView: (item) ->
      if typeof item.attributes.folder_id isnt 'undefined'
        TemplateItemView
      else
        TemplateCollectionView

    childViewContainer: '.gc-sidebar-sub'

    childViewOptions: (model, index) ->
      if model.items
        @_collectionViewOptions(model)
      else
        @_itemViewOptions(model)

    templateHelpers: ->
      type: @type
      name: @name
      isFolder: true

    viewComparator: (model) ->
      [
        !!model.get('folder_id') && 2 || 1
        _.underscored(model.get('name'))
      ]

    initialize: (options)->
      @type = options.type
      @collection = @model.items
      @name = @model.get('name')

    _collectionViewOptions: (model) ->
      type: @type
      name: model.get('name')
      collection: model.items

    _itemViewOptions: (model) ->
      attributes:
        'data-category': @name.toLowerCase()
      type: @type
      name: model.get('name')
