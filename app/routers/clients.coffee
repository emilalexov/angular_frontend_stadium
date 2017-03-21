define [
  'collections/clients'
  'collections/client_groups'
  'views/trainer/clients/clients-view'
  'views/trainer/clients/client-list-view'
  'views/trainer/clients/group-list-view'
], (
  Clients
  ClientGroups
  ClientsView
  ClientListView
  GroupListView
) ->

  class Router extends Marionette.AppRouter

    appRoutes:

      'clients(/)(/:view_type)': 'both'

  class Controller extends Marionette.Controller

    both: (viewType) ->
      user = App.request 'current_user'
      uid = user.get('id')
      if uid
        @renderClientList(uid)
      else
        @listenToOnce user, 'sync', =>
          @renderClientList(uid, viewType)

    renderClientList: (uid, viewType) ->
      view = new ClientsView
        viewType: viewType
      @_showView(view)

      collection = new Clients
      collection.url = "#{collection.url}/#{uid}/collections/clients"
      clientsView = new ClientListView
        collection: collection
      collection.fetch()
        .then ->
          view.clients.show(clientsView)
          view.initRegionListeners()

      collection = new ClientGroups
      collection.url = "#{collection.url}/#{uid}/collections/client_groups"
      clientGroupsView = new GroupListView
        collection: collection
      collection.fetch()
        .then ->
          view.groups.show(clientGroupsView)

    _showView: (view) ->
      App.request('views:show', view)

  Router: Router
  Controller: Controller
  init: ->
    new Router
      controller: new Controller
