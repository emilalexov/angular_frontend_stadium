config = require 'config'

ForgotPasswordModel = require 'models/auth/forgot-password-model'

class ForgotPasswordFormView extends Marionette.ItemView

  template: require('templates/auth/forgot-password')

  behaviors:

    form_validation: true

  ui:
    form: '.gc-forgot-password-form'
    emailField: '.gc-forgot-password-email'
    submitButton: 'button[type="submit"]'

  events:
    'submit @ui.form': 'submitForm'
    'keyup @ui.emailField': '_checkIfEmailValid'

  initialize: =>
    Backbone.Validation.bind @

  submitForm: (ev) =>
    formData = @ui.form.serializeObject()
    @model.set formData
    @model.save null,
      success: (model, data) =>
        @trigger 'next'
      error: (model, xhr, error) =>
        errors = xhr.responseJSON.error
        for key, value of errors
          message = value.join(', ')
          input = @ui.form.find("input[name='#{key}']")
          uiGroup = input.parents('.form-group')
          @trigger 'switchError', message , uiGroup

  _checkIfEmailValid: =>
    @model.set email: @ui.emailField.val()
    @model.validate()
    if @model.isValid()
      @ui.submitButton.removeClass('disabled')
    else
      @ui.submitButton.addClass('disabled')

class ForgotPasswordSuccessView extends Marionette.ItemView

  template: require('templates/auth/forgot_password_success')

module.exports = class ForgotPasswordView extends Marionette.LayoutView

  template: require('templates/auth/empty_layout')

  regions:
    signUp: '#gc-default-region'

  initialize: ->
    @formView = new ForgotPasswordFormView model: new ForgotPasswordModel
    @successView = new ForgotPasswordSuccessView
    @listenTo @formView, 'next', @nextStep
    @listenTo @successView, 'final', @final

  onShow: ->
    @signUp.show @formView

  nextStep: ->
    @signUp.show @successView

  final: ->
    true
