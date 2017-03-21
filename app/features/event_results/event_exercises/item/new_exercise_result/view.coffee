define [
  './template'
  './new_exercise_result_items/view'
  'collections/exercise_properties'
], (
  template
  NewExerciseResultItemsCollectionView
  ExerciseProperties
) ->

  class NewExerciseResultView extends Marionette.LayoutView

    className: 'workout-enter-results'

    template: template

    behaviors: ->

      regioned:
        views: [
            region: 'new_exercise_result_items'
            klass: NewExerciseResultItemsCollectionView
            options: ->
              collection: @properties
        ]

    events:
      'click .add-result-submit': 'addNewResult'

    initialize: ->
      @properties = new ExerciseProperties
      propertiesAttributes = @options.properties.getZeroedAttributes()
      @properties.reset(propertiesAttributes, parse: true)

    addNewResult: ->
      @trigger('add_new', @properties.models)
      _.defer(=> @properties.zeroValues())
