define [
  'behaviors/base/regioned'
  './view'
], (
  BaseRegionedBehavior
  BehaviorView
) ->

  class RatingWidgetBehavior extends BaseRegionedBehavior

    regionName: 'rating_widget'

    behaviorViewClass: BehaviorView

    behaviorViewOptions: ->
      model: @view.model
