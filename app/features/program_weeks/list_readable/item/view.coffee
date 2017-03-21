define [
  './template'
  'features/program_workouts/list_readable/view'
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
          '[data-bind="name"]':
            observe: 'name'
            events: ['change']

      regioned:
        views: [
            region: 'week_workouts'
            klass: ProgramWorkoutsListView
            options: ->
              program = @model.collection.program
              collection = new Backbone.VirtualCollection program.workouts,
                filter: (model) => model.get('week_id') == @model.get('id')
                comparator: 'position'
              collection.week_id = @model.get('id')

              weekId: @model.get('id')
              hasEmptyView: true
              model: program
              collection: collection
        ]