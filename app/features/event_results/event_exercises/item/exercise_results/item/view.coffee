define [
  './template'
  'features/event_results/event_exercises/item/exercise_properties/view'
], (
  template
  ExercisePropertiesCollectionView
) ->

  class ExerciseResultView extends Marionette.LayoutView

    template: template

    className: 'row middle-item'

    behaviors: ->

      stickit:
        bindings:
          '.personal-best-check':
            classes:
              active: 'is_personal_best'

      regioned:
        views: [
            region: 'exercise_properties'
            klass: ExercisePropertiesCollectionView
            options: ->
              collection: @model.exercise_result_items
        ]

    events:
      'click .personal-best-check': '_changeIsPersonalBest'
      'click .delete-button': '_remove'

    _changeIsPersonalBest: ->
      @model.patch(is_personal_best: !@model.get('is_personal_best'))

    _remove: ->
      App.request('modal:confirm:delete', @model)
