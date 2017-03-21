define [
  './item/view'
], (
  ItemView
) ->

  class ExerciseResultItemCollectionView extends Marionette.CollectionView

    tagName: 'list'

    childView: ItemView
