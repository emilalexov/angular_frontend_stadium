define [
  './template'
  './exercise_result_items_list/view'
], (
  template
  ExerciseResultItemCollectionView
) ->

  class PersonalBestItemView extends Marionette.LayoutView

    className: 'personal-best-item'

    template: template

    behaviors: ->

      stickit:
        bindings:
          '.title span': 'name'

      regioned:
        views: [
            region: 'exercise_result_items'
            klass: ExerciseResultItemCollectionView
            options: ->
              collection: @model.exercise_result_items
        ]

    events:
      'click .delete': '_destroyResult'

    _destroyResult: ->
      App.request('modal:confirm:delete', @model)
