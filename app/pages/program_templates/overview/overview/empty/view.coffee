define [
  './template'
], (
  template
) ->

  class EmptyProgramView extends Marionette.ItemView

    className: 'gc-program-empty-placeholder text-center'

    template: template

    model: new Backbone.Model

    behaviors:
      stickit:
        bindings:
          ':el':
            observe: 'count'
            visible: (value) -> !value

    initialize: ->
      @listenTo(@options.weeks, 'add remove reset', @_setCount)
      @listenTo(@options.workouts, 'add remove reset', @_setCount)

    _setCount: ->
      @model.set(count: @options.weeks.length + @options.workouts.length)
