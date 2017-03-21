define [
  './item/view'
  './empty/view'
], (
  ExercisesItemView
  EmptyView
) ->

  class WorkoutExercisesListView extends Marionette.CollectionView

    tagName: 'ul'

    className: 'gc-workout-exercises-list draggable-container'

    emptyView: EmptyView

    childView: ExercisesItemView

    childEvents:
      'edited': '_edited'

    behaviors:
      exercises_connectors: true

    viewComparator: (model) ->
      model.get('position')

    initialize: ->
      App.request 'fwd',
        context: @
        from: @
        to: @children
        each: true
        events: [
          'actions:multi_constructor:start'
          'actions:multi_constructor:stop'
          'actions:multi_constructor:assign'
        ]

      @listenTo(@, 'actions:add', @_addExerciseToCollection)
      @listenTo(@, 'actions:create', @_redirectToExercises)
      @listenTo(App.vent, 'drag_n_drop:item:dropped', @_handleDropped)

    _addExerciseToCollection: (id) =>
      @collection.addExercise
        exercise_id: id
        workout_id: @model.get('id')
        workout_type: @model.type
        order_name: @collection.length + 1
        position: @collection.length + 1

    _redirectToExercises: ->
      setTimeout ->
        App.vent.trigger 'redirect:to', ['exercises'],
          replace: false
      , 100

    _handleDropped: (el, target, source, sibling) ->
      @_updatePosition() if target is @el

    _updatePosition: ->
      @children.each (view) ->
        view.model.set
          position: view.$el.index()
        view.model.patch()
      @collection.sort()

    _edited: ->
      @trigger('edited')