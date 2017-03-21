define [
  './template'
  './exercise_properties/view'
  './exercise_results/view'
  './new_exercise_result/view'
], (
  template
  ExercisePropertiesCollectionView
  ExerciseResultCollectionView
  NewExerciseResultView
) ->

  class EventExerciseItemView extends Marionette.LayoutView

    template: template

    className: 'gc-workout-enter-result-view'

    behaviors: ->

      stickit:

        bindings:
          '.gc-workout-exercise-name': 'name'
          '.details-section span': 'note'
          '.details-section span':
            observe: 'note'
            visible: true
          '.gc-workout-exercise-circle':
            observe: 'order_name'
            attributes: [
                name: 'style'
                observe: 'color'
                onGet: (value) ->
                  "background-color: #{value}"
            ]


      regioned:
        views: [
            region: 'exercise_properties'
            klass: ExercisePropertiesCollectionView
            options: ->
              collection: @model.exercise_properties
          ,
            region: 'exercise_result_items'
            klass: ExerciseResultCollectionView
            options: ->
              collection: @model.exercise_results
          ,
            region: 'new_exercise_result'
            klass: NewExerciseResultView
            options: ->
              properties: @model.exercise_properties
        ]
    ui:
      addNewResultButton: '.add-btn.result-btn'

    events:
      'click @ui.addNewResultButton': '_onAddNewResultButtonClick'

    initialize: ->
      @listenTo(@, 'remove:results', @_removeResults)

    onShow: ->
      @listenTo(@views.new_exercise_result, 'add_new', @_onAddNewResult)

    _onAddNewResultButtonClick: ->
      @ui.addNewResultButton.toggleClass('opened')
      @views.new_exercise_result.$el.toggleClass('opened')

    _onAddNewResult: (properties) ->
      ExerciseResult = @model.exercise_results.model
      result = new ExerciseResult
        workout_event_id: @model.get('workout_event_id')
        workout_exercise_id: @model.get('workout_exercise_id')

      ResultItem = result.exercise_result_items.model
      resultItems = _.map(properties, _.bind(@_buildResultItem, @, ResultItem))

      @model.exercise_results.createWithItems(result, resultItems)
      @_onAddNewResultButtonClick()

    _buildResultItem: (ExerciseResultItem, prop) ->
      item = new ExerciseResultItem
      item.exercise_property.personal_property = prop.personal_property
      item.exercise_property.set(prop.attributes)
      item.set
        exercise_property_id: prop.id
        value: prop.get('value')
      item

    _removeResults: ->
      @model.exercise_results.destroyAll()
