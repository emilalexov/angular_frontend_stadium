define [
  'behaviors/base/regioned'
  './view'
], (
  BaseRegionedBehavior
  View
) ->

  class ActionsDropdownBehavior extends BaseRegionedBehavior

    regionName: 'actions_dropdown'

    behaviorViewClass: View

    behaviorViewOptions: ->
      model: _.bind(@options.model, @)()
      items: @options.items

    defaults:
      model: ->
        @view.model
      items: []
