define [
  './item/view'
], (
  ItemView
) ->

  class ListView extends Marionette.CollectionView

    childView: ItemView

    className: 'gc-folders-entity-list'

    tagName: 'ul'

    viewComparator: (model) ->
      _.underscore(model.get('name'))

    childViewOptions: ->
      user: @options.user

    initialize: ->
      @request = @collection.fetch()

    onBeforeDestroy: ->
      @request?.abort?()
