define ->

  class NavigateBackBehavior extends Marionette.Behavior

    key: 'navigate_back'

    ui:
      navBackButton: '.gc-content-nav-back'

    events:
      'click @ui.navBackButton': '_navigateBack'

    _navigateBack: (ev) ->
      ev.preventDefault()
      window.history.back()
