define [
  'behaviors/base/regioned'
  './view'
], (
  BaseRegionedBehavior
  PaginationView
) ->

  class PaginationBehavior extends BaseRegionedBehavior

    regionName: 'pagination'

    behaviorViewClass: PaginationView

    behaviorViewOptions: ->
      collection: @view.collection
