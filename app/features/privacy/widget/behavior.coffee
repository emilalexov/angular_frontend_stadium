define [
  'behaviors/base/regioned'
  './view'
], (
  BaseRegionedBehavior
  BehaviorView
) ->

  class PrivacyWidgetBehavior extends BaseRegionedBehavior

    regionName: 'privacy_widget'

    behaviorViewClass: BehaviorView

    behaviorViewOptions: ->
      model: _.bind(@options.model, @)()

    defaults:
      model: ->
        @view.model
