module.exports = class ResendConfirmationView extends Marionette.ItemView

  template: require('templates/auth/resend_confirmation')

  modelEvents:
    'model:auth_resend:success': 'onResendSuccess'
    'model:auth_resend:fail': 'onResendFailed'
    'invalid': 'onModelValidateFailed'

  onRender: ->
    Backbone.Validation.bind @

  ui:
    resendButton: 'button.resend-confirmation'
    emailInput: 'input[name=email]'
    resendFormControls: '.gc-resend-form-controls'
    resendSuccess: '.gc-resend-success'
    errorText: '.gc-resend-error-text'

  events:
    'click @ui.resendButton': 'resendInstructions'

  resendInstructions: ->
    @model.set 'email', @ui.emailInput.val()
    @model.resendConfirmation()

  onResendSuccess: ->
    @ui.errorText.addClass('hidden')
    @ui.resendFormControls.addClass 'hidden'
    @ui.resendSuccess.removeClass 'hidden'

  onResendFailed: (message) ->
    @ui.errorText.removeClass 'hidden'
    @ui.errorText.text message

  onModelValidateFailed: (model, error, options) ->
    @displayErrorText error.email

  displayErrorText: (message) ->
    @ui.errorText.text message
    @ui.errorText.removeClass 'hidden'
