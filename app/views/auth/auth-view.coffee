LoginModel = require 'models/auth/login-model'

module.exports = class AuthView extends Marionette.ItemView

  template: require('templates/auth/auth')

  events:
    'submit form': 'login'

  ui:
    form: '.gc-login-form'
    signUpModal: '#gc-signup-message'

  behaviors:
    facebook_login:
      isSignup: false
      isLinking: false
    google_login:
      isSignup: false
      isLinking: false

    stickit:
      bindings:
        'input[name="username"]': 'username'
        'input[name="password"]': 'password'
        '.gc-login-signup-wrapper':
          visible: ->
            feature.isEnabled('sign_up')

  initialize: (data) ->
    @model = new LoginModel
    @listenTo(@model, 'model:login:success', @_onLoginSuccess)
    @listenTo(@model, 'model:login:fail', @_onLoginFail, status)
    @signUp = data.signUp
    Backbone.Validation.bind(@)

  onShow: ->
    if @signUp
      @ui.signUpModal.modal 'show'

  login: ->
    # safari autocomplete hack
    @model.set
      username: @$('input[name="username"]').val()
      password: @$('input[name="password"]').val()
    @model.login()

  _onLoginSuccess: (data) ->
    App.request('auth:onSuccess', data)

  _onLoginFail: (status) ->
    App.request('messenger:explain', 'login.failed') unless status is 401
