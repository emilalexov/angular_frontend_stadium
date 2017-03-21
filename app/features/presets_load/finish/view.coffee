define [
  './template'
], (
  template
) ->

  class FinishModalView extends Marionette.ItemView

    template: template

    events:
      'click a.change-account-type': '_close'

    _close: ->
      settings = App.request('current_user').user_settings
      settings.save({is_presets_loaded: true}, wait: true)
      @trigger('modal:closed')
