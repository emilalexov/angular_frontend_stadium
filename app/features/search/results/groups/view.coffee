define [
  './item/view'
], (
  ItemView
) ->

  class View extends Marionette.CollectionView

    childView: ItemView
