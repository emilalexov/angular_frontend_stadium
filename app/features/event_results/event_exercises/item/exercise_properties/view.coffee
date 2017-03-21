define [
  './item/view'
], (
  ExercisePropertiesItemView
) ->

  class ExercisePropertiesCollectionView extends Marionette.CollectionView

    className: 'property-items'

    childView: ExercisePropertiesItemView
