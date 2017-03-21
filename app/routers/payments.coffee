define [
  'pages/payments/overview/page'
  'features/payment/info/view'
], (
  PaymentsOverviewPage
  PaymentsInfoPage
) ->

  class Router extends Marionette.AppRouter

    appRoutes:

      'payments(/)': 'root'
      'payments/info': 'info'
      'payments/:state': 'overview'

  class Controller extends Marionette.Controller

    root: ->
      path = ['payments', 'transactions']
      App.vent.trigger('redirect:to', path)

    overview: (state) ->
      new PaymentsOverviewPage
        state: state

    info: ->
      view = new PaymentsInfoPage
      App.request 'views:show', view,
        layout: 'auth'
        region: 'content'

    _showView: (view) ->
      App.request('views:show', view)

  Router: Router
  Controller: Controller
  init: ->
    new Router
      controller: new Controller
