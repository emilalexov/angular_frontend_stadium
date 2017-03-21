define [
  './collection'
  './item/view'
], (
  Collection
  ItemView
)->

  class View extends Marionette.CollectionView

    tagName: 'ul'

    className: 'gc-content-nav'

    childView: ItemView

    childEvents:
      'switch': '_onSwitch'

    collectionEvents:
      'activated': '_onActivated'

    constructor: (options) ->
      @collection = options.collection ||
        _.any(options.data) && new Collection(options.data) ||
        undefined
      super

    initialize: ->
      @listenTo(@, 'activate', @_onActivate)

    _onSwitch: (view) =>
      id = view.model.get('id')
      @trigger('activate', id)

    _onActivate: (id) ->
      @collection.trigger('activate', id)

    _onActivated: (id) ->
      @trigger('activated', id)
