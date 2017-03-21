define [
  './template'
  './list/view'
  './actions/view'
], (
  template
  ListView
  ActionsView
) ->

  class View extends Marionette.LayoutView

    template: template

    className: 'gc-workouts-exercises-view'

    behaviors:

      regioned:
        views: [
            region: 'workout_exercises_list'
            klass: ListView
          ,
            region: 'workout_exercises_actions'
            klass: ActionsView
            enabled: ->
              can('update', @model)
        ]

    initialize: ->
      @listenTo(@collection, 'add remove', @_actionsVisibility)

    onShow: ->
      App.request 'fwd',
        context: @
        from: @views.workout_exercises_actions
        to: @views.workout_exercises_list
        events: [
          'actions:add'
          'actions:create'
          'actions:multi_constructor:start'
          'actions:multi_constructor:stop'
          'actions:multi_constructor:assign'
        ]
      App.request 'fwd',
        context: @
        from: @
        to: @views.workout_exercises_actions
        events: [
          'actions:hide'
          'actions:show'
        ]

      @listenTo @views.workout_exercises_list, 'edited', => @trigger('edited')

      @listenToOnce @views.workout_exercises_actions, 'show',
        @_actionsVisibility

    _actionsVisibility: ->
      if @collection.length > 1
        @trigger 'actions:show'
      else
        @trigger 'actions:hide'
