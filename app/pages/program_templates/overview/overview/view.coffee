define [
  './template'
  'features/program_weeks/list/view'
  'features/program_weeks/list_readable/view'
  'features/program_workouts/list/view'
  'features/program_workouts/list_readable/view'
  './empty/view'
  'models/program_workout'
], (
  template
  ProgramWeeksListView
  ReadableProgramWeeksListView
  ProgramWorkoutsListView
  ReadableProgramWorkoutsListView
  EmptyView
  ProgramWorkout
) ->

  class View extends Marionette.LayoutView

    template: template

    className: 'gc-box-content'

    behaviors:

      editable_textarea: true

      program_action_panel_bottom:
        model: -> @view.model
        enabled: ->
          can('update', @view.options.model)

      regioned:
        views: [
            region: 'program_empty'
            klass: EmptyView
            options: ->
              weeks: @model.weeks
              workouts: @model.workouts
        ]

    regions:
      program_weeks: 'region[data-name="program_weeks"]'
      program_workouts: 'region[data-name="program_workouts"]'

    initialize: ->
      @listenTo(@model, 'sync', @_renderWorkouts)

    _renderWorkouts: ->
      Views = if can('update', @model)
        program_weeks: ProgramWeeksListView
        program_workouts: ProgramWorkoutsListView
      else
        program_weeks: ReadableProgramWeeksListView
        program_workouts: ReadableProgramWorkoutsListView

      options =
        program_weeks:
          collection: @model.weeks
        program_workouts:
          model: @model
          collection: new Backbone.VirtualCollection @model.workouts,
            filter: (model) -> !model.get('week_id')
            comparator: 'position'

      _.each ['program_weeks', 'program_workouts'], (name) =>
        view = @views[name] = new Views[name](options[name])
        view.listenTo(view, 'add:child', @_onAddChild)
        region = @getRegion(name)
        region.show(view)

    _onAddChild: (childView) ->
      childView.el.scrollIntoViewIfNeeded?()
