define [
  './template'
], (
  template
) ->
  class WorkoutItemView extends Marionette.ItemView

    template: template

    tagName: 'li'

    className: 'gc-workout-draggable'

    ui:
      workoutItemTabs: '.gc-workout-body-nav a'
      workoutTabs: '.gc-workout-tab-content'
      workoutTabPanes: '.gc-workout-tab-content .tab-pane'
      bookmark: '.gc-workout-bookmark'
      deleteWorkout: '.gc-delete-program-workout'
      workoutTitle: '.gc-workout-title > span'

    events:
      'click @ui.workoutItemTabs': '_toggleTabs'
      'click @ui.deleteWorkout': '_removeProgramWorkout'
      'keypress @ui.workoutTitle': '_saveOnEnter'
      'change input[data-bind="is_visible"]': '_saveVisibility'

    behaviors:

      stickit:
        bindings:
          '[data-bind="workout-name"]':
            observe: 'name'
            events: ['blur']
          '[data-bind="description"]':
            observe: 'description'
            events: ['change']

    modelEvents:
      'change:name': '_saveOnChange'
      'change:description': '_saveOnChange'

    initialize: (options) ->
      @program_template = options.program_template
      @$el.attr 'data-id', @model.get('id')

    changeContent: (content) ->
      @ui.workoutTabPanes.removeClass 'active'
      @ui.workoutTabs.find("[data-pane=#{content}]").addClass 'active'

    _toggleTabs: (event) ->
      target = $(event.currentTarget)
      content = target.attr 'data-content'
      @ui.workoutItemTabs.removeClass 'active'
      target.addClass 'active'
      @changeContent content

    _removeProgramWorkout: (ev) ->
      @model.destroy().then ->
        App.request('messenger:explain', 'workout.deleted')

    _saveOnEnter: (ev) ->
      if ev.which is 13
        ev.preventDefault()
        @ui.workoutTitle.blur()

    _saveOnChange: (_model, _value) ->
      @model.save()

    _saveVisibility: (ev) ->
      isVisible = ev.currentTarget.checked
      @model.workout.save(is_visible: isVisible)

    _positionChanged: ->
      @model.set 'position', @$el.index() + 1
      @model.save()
