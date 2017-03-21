define [
  './behavior'
], (
  ProgramActionPanelBehavior
) ->

  class ProgramActionPanelBottomBehavior extends ProgramActionPanelBehavior

    regionName: 'program_action_panel_bottom'

    behaviorViewOptions: ->
      position: 'bottom'
      model: _.bind(@options.model, @)()
