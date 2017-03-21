# NOTE: not used anymore
define [
  './template'
  'features/quick_add/view'
], (
  template
  QuickAddView
) ->

  class View extends Marionette.LayoutView

    template: template

    className: 'col col-lg-6'

    triggers:
      'click button[data-name="build"]': 'program_workouts:build'

    behaviors:
      regioned:
        views: [
            region: 'quick_add'
            klass: QuickAddView
            options: ->
              collection: App.request('current_user').workout_templates
              typeToAdd: 'Workout'
        ]

    onShow: ->
      @listenTo @views.quick_add, 'quick_add:chosen', (id) =>
        if id is '0'
          @trigger('actions:create')
        else
          @trigger('actions:add', id)
