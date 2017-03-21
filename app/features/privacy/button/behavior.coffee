define [
  'behaviors/base/regioned'
  './view'
], (
  BaseRegionedBehavior
  BehaviorView
) ->

  class PrivacyButtonBehavior extends BaseRegionedBehavior

    regionName: 'privacy_button'

    behaviorViewClass: BehaviorView

    behaviorViewOptions: ->
      model: _.bind(@options.model, @)()

    defaults:
      model: ->
        @view.model
