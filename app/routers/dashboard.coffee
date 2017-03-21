define [
  'pages/dashboard/client/page'
  'pages/dashboard/pro/page'
  'features/stats/collection'
  'features/stats/view'
], (
  ClientDashboard
  TrainerDashboard
  StatsCollection
  StatsCompositeView
) ->

  class Router extends Marionette.AppRouter

    appRoutes:

      'welcome' : 'stats'
      'dashboard/client': 'client_dashboard'
      'dashboard/pro': 'pro_dashboard'

  class Controller extends Marionette.Controller

    stats: ->
      user = App.request('current_user')
      # collection = new StatsCollection
      # collection.build(user)
      # view = new StatsCompositeView
      #   collection: collection
      # @_showView(view)

      if user.get('is_pro')
        @pro_dashboard()
      else
        @client_dashboard()


    client_dashboard: ->
      new ClientDashboard

    pro_dashboard: ->
      new TrainerDashboard

    # _showView: (view) ->
    #   App.request('views:show', view)

  Router: Router
  Controller: Controller
  init: ->
    new Router
      controller: new Controller
