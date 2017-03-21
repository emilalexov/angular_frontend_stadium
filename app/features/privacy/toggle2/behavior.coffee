define [
  'behaviors/base/regioned'
  './view'
], (
  BaseRegionedBehavior
  BehaviorView
) ->

  class PrivacyToggleBehavior extends BaseRegionedBehavior

    regionName: 'privacy_toggle2'

    behaviorViewClass: BehaviorView

    behaviorViewOptions: ->
      model: @view.model
      instantSave: @options.instantSave

    defaults:
      instantSave: true