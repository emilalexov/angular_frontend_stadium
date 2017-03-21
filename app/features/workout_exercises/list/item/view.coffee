define [
  './template'
  'features/exercise_properties/list/view'
], (
  template
  ExercisePropertiesListView
) ->

  class WorkoutExercisesListItemView extends Marionette.LayoutView

    key: 'WorkoutExercisesListItemView'

    template: template

    tagName: 'li'

    className: 'gc-workout-exercise-item'

    ui:
      deleteBtn: '.gc-delete-exercise'
      addSingleProperty: '.gc-add-single-property-button'
      setPropertyCheckboxWrapper: '.gc-set-property-checkbox-wrapper'
      setPropertyCheckbox: '.gc-set-property-checkbox'
      note: '.gc-workout-exercise-note'

    events:
      'click @ui.deleteBtn': 'deleteExercise'
      'click @ui.addSingleProperty': 'initProperty'
      'keypress .gc-workout-exercise-circle': '_typeAllowedChars'

    behaviors:

      regioned:
        views: [
          klass: ExercisePropertiesListView
          region: 'exercise_properties'
          options: ->
            collection: @model.exercise_properties
        ]

      stickit:
        bindings:
          ':el':
            classes:
              'hover-enabled':
                observe: 'state'
                onGet: (value) ->
                  value isnt 'edit'
          '.gc-workout-exercise-sort':
            attributes: [
                observe: 'id'
                name: 'data-workout-id'
              ,
                observe: 'exercise_id'
                name: 'data-id'
              ,
                observe: 'position'
                name: 'data-position'
            ]
          '.gc-workout-exercise-circle-cell':
            attributes: [
                name: 'data-order_position'
                observe: 'order_position'
            ]
          '.gc-workout-exercise-circle, .line-top, .line-bottom':
            attributes: [
                name: 'style'
                observe: 'color'
                onGet: (value) ->
                  "background-color: #{value}"
            ]
          '.gc-workout-exercise-circle':
            observe: 'order_name'
            events: ['blur']
            getVal: ($el) ->
              $el.text().toUpperCase()
            attributes: [
                name: 'tabindex'
                observe: 'position'
            ]
          '.gc-workout-exercise-note':
            observe: 'note'
            events: ['blur']
            classes:
              'empty':
                observe: 'note'
                onGet: (value) ->
                  "#{value}".length is 0
          '.gc-workout-exercise-name':
            observe: 'name'
            attributes: [
                name: 'href'
                observe: 'exercise_id'
                onGet: (value) ->
                  "#exercises/#{value}"
            ]

    initialize: (options) ->
      @listenTo @model, 'change:note change:order_name change:position', =>
        @model.patch().then =>
          @trigger('edited')
      @listenTo(@, 'actions:multi_constructor:start', @enableCheckbox)
      @listenTo(@, 'actions:multi_constructor:stop', @disableCheckbox)
      @listenTo(@, 'actions:multi_constructor:assign', @addProperties)

    onShow: ->
      @listenTo(@views.exercise_properties, 'edited', -> @trigger('edited'))

    enableCheckbox: =>
      @ui.setPropertyCheckboxWrapper.removeClass 'hidden'
      @$el.removeClass 'hover-enabled'

    disableCheckbox: =>
      @ui.setPropertyCheckboxWrapper.addClass 'hidden'
      @ui.setPropertyCheckbox.attr 'checked', false
      @$el.addClass 'hover-enabled'

    deleteExercise: ->
      App.request 'modal:confirm:delete', @model

    initProperty: ->
      @views.exercise_properties.trigger 'properties:init',
        workout_exercise_id: @model.get('id')

    addProperties: (exercise_properties) =>
      if @ui.setPropertyCheckbox.is(':checked')
        @views.exercise_properties.trigger 'properties:add',
          exercise_properties: exercise_properties
          workout_exercise_id: @model.get('id')
      @trigger('actions:multi_constructor:stop')

    _typeAllowedChars: (ev) ->
      return false if ev.currentTarget.innerText.length >= 3
      char = String.fromCharCode(ev.keyCode || ev.which)
      re = /[a-z\d]/i
      return false if not char.match(re)
