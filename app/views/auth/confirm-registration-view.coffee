module.exports = class ConfirmRegistrationView extends Marionette.ItemView

  template: require('templates/auth/confirm_registration')

  initialize: (options) ->
    @token = options.token

  modelEvents:
    'model:auth_confirm:fail': 'confirmFailed'
    'model:auth_confirm:success': 'confirmSuccess'

  onRender: ->
    @model.confirm @token

  confirmFailed: ->
    # todo: implement resending of confirmation email

  confirmSuccess: (data) ->
    App.vent.trigger('redirect:to', '#', replace: true)
