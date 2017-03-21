define [
  'behaviors/base/regioned'
  './view'
], (
  BaseRegionedBehavior
  BreadcrumbsView
) ->

  class BreadcrumbsBehavior extends BaseRegionedBehavior

    regionName: 'breadcrumbs'

    behaviorViewClass: BreadcrumbsView

    behaviorViewOptions: ->
      model: _.bind(@options.model, @)
      editable: @options.editable

    defaults:
      model: ->
        @view.model
      editable: true
