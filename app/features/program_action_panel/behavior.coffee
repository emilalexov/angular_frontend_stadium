define [
  'behaviors/base/regioned'
  './editable/view'
  './readable/view'
], (
  BaseRegionedBehavior
  EditableBehaviorView
  ReadableBehaviorView
) ->

  class ProgramActionPanelBehavior extends BaseRegionedBehavior

    regionName: 'program_action_panel'

    behaviorViewClass: undefined

    initialize: ->
      @behaviorViewClass = if @_isReadonly()
        ReadableBehaviorView
      else
        EditableBehaviorView
      super

    _isReadonly: ->
      if _.isFunction(@options.readonly)
        _.bind(@options.readonly, @view)()
      else
        @options.readonly

    behaviorViewOptions: ->
      position: 'top'
      model: _.bind(@options.model, @)()

    defaults:
      model: ->
        @view.model
