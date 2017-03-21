define [
  './item/view'
  './empty/view'
], (
  EntityItemView
  EntityEmptyView
) ->

  class EntityListView extends Marionette.CollectionView

    tagName: 'ul'

    className: 'gc-folders-entity-list'

    emptyView: EntityEmptyView

    childView: EntityItemView

    childViewContainer: 'ul'

    collectionEvents:
      'sync': 'render'
      'highlight': 'highlightNew'

    ui:
      checkboxWrappers: 'gc-folders-entity-list'

    childViewOptions: =>
      'type': @typeName

    childEvents:
      'item:clicked': 'itemSelected'
      'folder:change': 'changeFolder'

    viewComparator: (model) ->
      isFolder = _.isUndefined(model.get('folder_id'))
      [
        isFolder && 1 || 2
        _.underscored(model.get('name'))
      ]

    initialize: (data) =>
      @on('items:delete', @_deleteItems)
      @typeName = data.type

    itemSelected: =>
      @trigger 'item:clicked'

    changeFolder: (view, id) =>
      item = @collection.findWhere 'id': id

      if item
        item.save('folder_id': view.model.get('id'))
          .then =>
            profileModel = App.request 'current_user'
            folder = profileModel.folders.get(view.model.get('id'))
            folder.items.add item
            @collection.remove item

            App.request 'messenger:explain', 'item.moved',
              item: item.get('name')
              folder: folder.get('name')

    highlightNew: (model) =>
      if model
        $row = @ui.checkboxWrappers.find("[data-id=#{model.id}]")
          .closest('.row')
        $row.addClass 'active'
        $('html, body').animate({
          scrollTop: $row.offset().top
        }, 1000)
        setTimeout ->
          $row.removeClass 'active'
        , 3000

    _deleteItems: (ids, rootId) =>
      deletions = _.map ids, (id) =>
        model = @collection.get(id)
        model.destroy(wait: true)
      $.when(deletions...)
        .then ->
          App.request('messenger:explain', 'item.deleted')
        .fail ->
          App.request('messenger:explain', 'item.not_deleted')
