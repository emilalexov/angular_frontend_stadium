define ->

  class MobileOnlyFeatures extends Marionette.Behavior

    key: 'mobile_only_features'

    events:
      'click [data-mobile-only]': '_notifyUser'

    _notifyUser: (ev) ->
      !App.request('messenger:explain', 'error.mobile_only')
