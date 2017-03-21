define [
  'behaviors/base/regioned'
  './view'
], (
  BaseRegionedBehavior
  BreadcrumbsView
) ->

  class AddToLibraryButtonBehavior extends BaseRegionedBehavior

    regionName: 'add_to_library'

    behaviorViewClass: BreadcrumbsView

    behaviorViewOptions: ->
      model: _.bind(@options.model, @)()

    defaults:
      model: ->
        @view.model
