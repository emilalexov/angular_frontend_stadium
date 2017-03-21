define [
  './item/view'
  './empty/view'
], (
  ItemView
  EmptyView
) ->

  class PersonalBestCollectionView extends Marionette.CollectionView

    tagName: 'list'

    childView: ItemView

    emptyView: EmptyView

    emptyViewOptions: ->
      model: @options.user
