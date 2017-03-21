define [
  './item/view'
], (
  ExerciseResultView
) ->

  class ExerciseResultCollectionView extends Marionette.CollectionView

    className: 'workout-enter-middle'

    childView: ExerciseResultView
