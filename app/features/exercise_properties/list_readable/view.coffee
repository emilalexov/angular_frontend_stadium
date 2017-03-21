define [
  './item/view'
], (
  ItemReadableView
) ->

  class ExercisePropertiesReadableListView extends Marionette.CollectionView

    tagName: 'ul'

    className: 'workout-exercise-properties'

    childView: ItemReadableView
