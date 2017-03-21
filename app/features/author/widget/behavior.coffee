define [
  'behaviors/base/regioned'
  './view'
], (
  BaseRegionedBehavior
  BehaviorView
) ->

  class AuthorWidgetBehavior extends BaseRegionedBehavior

    regionName: 'author_widget'

    behaviorViewClass: BehaviorView

    behaviorViewOptions: ->
      parent: _.bind(@options.model, @)()

    defaults:
      model: ->
        @view.model
