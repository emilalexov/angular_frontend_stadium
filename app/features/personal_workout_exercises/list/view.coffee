define [
  './item/view'
  'features/workout_exercises/list/empty/view'
], (
  ExercisesItemView
  EmptyView
) ->

  class WorkoutExercisesListView extends Marionette.CollectionView

    tagName: 'ul'

    className: 'gc-workout-exercises-list'

    emptyView: EmptyView

    childView: ExercisesItemView

    behaviors:
      exercises_connectors: true

    viewComparator: 'position'