define [
  './item/view'
], (
  ItemView
) ->

  class View extends Marionette.CollectionView

    tagName: 'ul'

    className: 'gc-content-nav'

    childView: ItemView
