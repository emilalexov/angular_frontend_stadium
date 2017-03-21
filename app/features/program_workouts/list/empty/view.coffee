define [
  './template'
  'features/quick_add/view'
], (
  template
  QuickAddView
) ->

  class View extends Marionette.LayoutView

    template: template

    className: 'gc-week-workouts-empty'

    triggers:
      'click >button': 'actions:create'

    behaviors:
      regioned:
        views: [
            region: 'quick_add'
            klass: QuickAddView
            options: ->
              tagName: 'span'
              isIconHidden: true
              buttonName: 'Quick Add'
              collection: App.request('current_user').workout_templates
              typeToAdd: 'Workout'
        ]

    onShow: ->
      @listenTo @views.quick_add, 'quick_add:chosen', (id) =>
        if id is '0'
          @trigger('actions:create')
        else
          @trigger('actions:add', id)