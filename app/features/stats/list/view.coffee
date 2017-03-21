define [
  './item/view'
], (
  StatsItemView
) ->

  class StatsCollectionView extends Marionette.CollectionView

    tagName: 'ul'

    className: 'gc-folders-entity-list'

    childView: StatsItemView
