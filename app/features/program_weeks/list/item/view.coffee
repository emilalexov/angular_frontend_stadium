define [
  './template'
  'features/program_workouts/list/view'
], (
  template
  ProgramWorkoutsListView
) ->

  class ProgramWeeksListItemView extends Marionette.LayoutView

    template: template

    className: 'gc-program-week-item'

    behaviors:

      stickit:
        bindings:
          '[data-bind="name"]': 'name'
          '.workouts-count':
            observe: 'workouts_count'
            onGet: (value) ->
              "(#{value})"

      regioned:
        views: [
            region: 'week_workouts'
            klass: ProgramWorkoutsListView
            options: ->
              weekId: @model.get('id')
              hasEmptyView: true
              model: @program
              collection: @workouts
        ]

    ui:
      removeWeek: '.gc-remove-program-week'
      editButton: '.gc-program-week-actions .fa-edit'

    events:
      'click @ui.editButton': '_editName'
      'click @ui.removeWeek': 'removeModel'
      'click .gc-program-week-title': '_toggleWeek'

    initialize: ->
      @program = @model.collection.program
      @workouts = new Backbone.VirtualCollection @program.workouts,
        filter: (model) => model.get('week_id') == @model.get('id')
        comparator: 'position'
      @workouts.week_id = @model.get('id')
      @listenTo(@workouts, 'add remove reset', @_countWorkouts)
      @_countWorkouts()

    _countWorkouts: ->
      @model.set(workouts_count: @workouts.length)

    removeModel: ->
      App.request('modal:confirm:delete', @model)

    _editName: ->
      App.request 'modal:prompt',
        title: 'Edit Week Name'
        prompt: @model.get('name')
        confirmBtn: 'Rename'
        cancelCallBack: -> # nothing
        confirmCallBack: (name) => @model.patch(name: name)

    _toggleWeek: ->
      @$el.toggleClass('folded')
