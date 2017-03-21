define [
  './item/view'
], (
  NewExerciseResultItemView
) ->

  class NewExerciseResultItemsCollectionView extends Marionette.CollectionView

    tagName: 'form'

    childView: NewExerciseResultItemView
