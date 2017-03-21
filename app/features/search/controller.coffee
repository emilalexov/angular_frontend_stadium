define [
  './results/view'
], (
  SearchResultsView
) ->

  class Controller extends Marionette.Controller

    search: (q, entityType = 'all', searchScope = 'public') ->
      collection =
        App.request('search:request:collection')
      model =
        App.request('search:request:model')
      model.set
        q: q
        entity_type: entityType
        search_scope: searchScope
      view = new SearchResultsView
        collection: collection
        model: model
      App.request('views:show', view)
