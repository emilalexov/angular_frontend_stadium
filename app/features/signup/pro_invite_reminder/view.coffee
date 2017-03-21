define [
  './template'
  '../pro_invite/model'
  '../behavior'
], (
  template
  Model
  AuthBodyClassBehavior
) ->

  class ProInviteReminderView extends Marionette.ItemView

    template: template

    events:
      'click button': '_invite'


    behaviors:
      authBodyClass:
        behaviorClass: AuthBodyClassBehavior

    initialize: ->
      @model = new Model

    _invite: ->
      @model.invite()
        .then(@_onInvite)

    _onInvite: ->
      App.vent.trigger 'redirect:to', ['auth', 'pro_invite_success'],
        replace: false
