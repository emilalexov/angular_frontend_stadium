# NOTE: not used anymore, to delete
define [
  './item/view'
  './collection'
], (
  ItemView
  Collection
) ->

  class View extends Marionette.CollectionView

    childView: ItemView

    className: 'gc-block-group gc-program-counter clearfix'

    initialize: (options) ->
      @collection = new Collection(options.collections)
