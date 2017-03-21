define [
  'behaviors/base/regioned'
  './view'
], (
  BaseRegionedBehavior
  BehaviorView
) ->

  class PrivacyToggleBehavior extends BaseRegionedBehavior

    regionName: 'privacy_toggle'

    behaviorViewClass: BehaviorView

    behaviorViewOptions: ->
      model: @view.model