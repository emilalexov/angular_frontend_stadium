define [
  './template'
  './program_list/view'
], (
  template
  ProgramListView
) ->
  class ProgramPresetItemView extends Marionette.LayoutView

    template: template

    tagName: 'li'

    className: 'account-type-item'

    events:
      'click': 'changeSelected'

    behaviors: ->

      stickit:
        bindings:
          ':el':
            classes:
              active: 'is_selected'
          'h5': 'name'
          '.account-selected':
            classes:
              assigned: 'is_selected'

      regioned:
        views: [
          region: 'program_list'
          klass: ProgramListView
          options: ->
            collection: @model.program_templates
        ]

    changeSelected: ->
      is_selected = !@model.get('is_selected')
      @model.set(is_selected: is_selected)
