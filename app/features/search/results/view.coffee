define [
  './template'
  './groups/view'
  './public_scopes/collection'
  './public_scopes/view'
  './filters/collection'
  './filters/view'
], (
  template
  GroupsView
  SearchScopes
  SearchScopesView
  SearchFilters
  SearchFiltersView
) ->

  class View extends Marionette.LayoutView

    className: 'gc-search-results-main'

    template: template

    regions:
      publicScopes: 'region[data-name="public-scopes"]'
      resultGroups: 'region[data-name="search-results"]'
      searchFilters: 'region[data-name="search-filters"]'

    initialize: ->
      @_initCollections()

    onShow: ->
      view = new GroupsView
        collection: @collection
      @getRegion('resultGroups').show(view)

      view = new SearchScopesView
        collection: @searchScopes
        model: @model
      # @getRegion('publicScopes').show(view)

      view = new SearchFiltersView
        collection: @searchFilters
      @getRegion('searchFilters').show(view)

    _initCollections: ->

      q = @model.get('q')
      entityType = @model.get('entity_type')
      searchScope = @model.get('search_scope')

      @searchScopes = new SearchScopes [
          name: 'gymcloud'
          value: 'public'
          inScope: searchScope == 'public'
      ]

      @searchFilters = new SearchFilters [
          name: 'All'
          isSelected: entityType == 'all'
          href: "#search/#{q}"
        ,
          name: 'Exercises'
          isSelected: entityType == 'exercises'
          href: "#search/#{q}/exercises"
        ,
          name: 'Workouts'
          isSelected: entityType == 'workouts'
          href: "#search/#{q}/workouts"
        ,
          name: 'Programs'
          isSelected: entityType == 'programs'
          href: "#search/#{q}/programs"
        ,
          name: 'Clients'
          isSelected: entityType == 'clients'
          href: "#search/#{q}/clients"
        ,
          name: 'Groups'
          isSelected: entityType == 'client_groups'
          href: "#search/#{q}/client_groups"
      ]
