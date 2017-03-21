define [
  './item/view'
], (
  ItemView
) ->

  class CardList extends Marionette.CollectionView

    tagName: 'list'

    childView: ItemView
