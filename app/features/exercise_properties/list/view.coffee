define [
  './item/readable/view'
  './item/editable/view'
  './empty/view'
], (
  ItemReadableView
  ItemEditableView
  EmptyView
) ->

  class ExercisePropertiesListView extends Marionette.CollectionView

    tagName: 'ul'

    className: 'workout-exercise-properties'

    emptyView: EmptyView

    getChildView: (model) =>
      if @editableStateId is model.cid
        ItemEditableView
      else
        ItemReadableView

    childEvents:
      'switchTo:editable': '_switchToEditable'
      'switchTo:readable': '_switchToReadable'
      'edited': '_edited'

    initialize: ->
      @editableStateId = null
      @default_property = App.request('data:personal_properties:visible')
        .first().attributes
      @listenTo(@, 'properties:init', @initProperty)
      @listenTo(@, 'properties:add', @addProperties)

    initProperty: (options = {}) ->
      model = @collection.initProperty(
        options.workout_exercise_id,
        @default_property
      )
      childView = @children.findByModel(model)
      @_switchViewStateFor(childView, 'editable')

    addProperties: (options = {}) ->
      @collection.addProperties(
        options.exercise_properties,
        options.workout_exercise_id
      ).then =>
        @trigger('edited')

    _switchToEditable: (childView) ->
      @_switchViewStateFor(childView, 'editable')

    _switchToReadable: (childView) ->
      @_switchViewStateFor(childView, 'readable')

    _switchViewStateFor: (childView, state = 'readable') ->
      if state is 'readable'
        @editableStateId = null
      else
        @editableStateId = childView.model.cid
      @collection.remove(childView.model)
      @collection.add(childView.model, at: childView._index)

    _edited: ->
      @trigger('edited')