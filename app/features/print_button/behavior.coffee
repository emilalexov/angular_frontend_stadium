define [
  'behaviors/base/regioned'
  './view'
], (
  BaseRegionedBehavior
  BehaviorView
) ->

  class PrivacyButtonBehavior extends BaseRegionedBehavior

    regionName: 'print_button'

    behaviorViewClass: BehaviorView
