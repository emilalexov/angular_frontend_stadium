define [
  './template'
  './model'
  '../behavior'
], (
  template
  Model
  AuthBodyClassBehavior
) ->

  class TrainerInviteView extends Marionette.ItemView

    template: template

    behaviors: ->

      authBodyClass:
        behaviorClass: AuthBodyClassBehavior

      stickit:
        bindings:
          'input[name="name"]': 'name'
          'input[name="email"]': 'email'

    events:
      'submit form': '_onFormSubmit'

    initialize: ->
      @model = new Model

    _onFormSubmit: ->
      @model.save()
        .then(_.bind(@_invite, @))

    _invite: ->
      email = @model.get('email')
      @model.invite(email)
        .then(@_onInvite)

    _onInvite: ->
      App.vent.trigger 'redirect:to', ['auth', 'pro_invite_success'],
        replace: false
