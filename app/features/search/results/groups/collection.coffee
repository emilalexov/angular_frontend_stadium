define [
  './model'
], (
  SearchResultItem
) ->

  class SearchResultItems extends Backbone.Collection

    type: 'SearchResultItems'

    model: SearchResultItem
