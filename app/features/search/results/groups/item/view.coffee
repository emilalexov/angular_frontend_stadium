define [
  '../../entities/item/view'
  '../../entities/client/view'
  '../collection'
], (
  ItemView
  ClientItemView
  Collection
) ->

  class View extends Marionette.CollectionView

    tagName: 'ul'

    className: 'gc-search-results-list'

    initialize: (opts)->
      @collection = new Collection(opts.model.get('items'))
      @collection.klass = @model.get('klass')

    getChildView: (model) ->
      if _.include(['User', 'ClientGroup'], @model.get('klass'))
        ClientItemView
      else
        ItemView

    childViewOptions: ->
      entity_context:
        _.chain(@model.get('klass')).humanize().titleize().pluralize().value()
