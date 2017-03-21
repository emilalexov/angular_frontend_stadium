define [
  './model'
  './template'
], (
  AccountModel
  Template
) ->

  class SignupView extends Marionette.ItemView

    template: Template

    modelEvents:
      'account:created': 'onAccountCreated'

    behaviors:
      form_validation: true
      facebook_login:
        isSignup: true
        isLinking: false
      google_login:
        isSignup: true
        isLinking: false

      stickit:
        bindings:
          '[data-bind="first_name"]': 'first_name'
          '[data-bind="last_name"]': 'last_name'
          '[data-bind="password"]': 'password'
          '[data-bind="password_confirmation"]': 'password_confirmation'
          '[data-bind="agree"]': 'agree'
          '[data-bind="email"]':
            observe: 'email'
            attributes: [
                name: 'disabled'
                observe: 'invitation_token'
            ]
          '.gc-user-type-trainer':
            classes:
              active:
                observe: 'is_client'
                onGet: (value) -> !value
          '.gc-user-type-client':
            classes:
              active: 'is_client'
          '.gc-signup-with-email-title':
            observe: 'is_client'
            visible: (value) -> !value
          '.gc-login-social':
            observe: 'is_client'
            visible: (value) -> !value

    ui:
      'form': 'form.gc-signup-form'

    events:
      'submit @ui.form': 'createAccount'
      'blur input': 'validateInput'
      'click .gc-signup-checkbox input': '_onChangeUserType'

    initialize: (options) ->
      Backbone.Validation.bind @
      @model.set(is_client: !!@model.get('invitation_token'))

    validateInput: (ev) ->
      $input = $(ev.target)
      input_name = $input.attr('name')
      input_value = $input.val()
      return unless input_value

      $inputGroup = $input.closest('.form-group')
      error_msg = @model.preValidate(input_name, input_value)
      @trigger('switchError', error_msg, $inputGroup)

    createAccount: ->
      # safari autocomplete hack
      fields = [
        'first_name'
        'last_name'
        'email'
        'password'
        'password_confirmation'
      ]

      @model.set _.reduce(fields, ((memo, field) ->
        memo[field] = @$("input[name='#{field}']").val()
        memo
      ), {}, @)

      if @model.get('invitation_token')
        @model.acceptInvite()
      else
        @model.createAccount()
          .then =>
            if @model.get('is_client')
              return App.vent.trigger('redirect:to', ['auth', 'client_signup'])

    onAccountCreated: (data, _userProfile)->
      App.request('auth:onSuccess', data)
      @trigger 'signup:complete'

    _onChangeUserType: (ev) ->
      return ev if @model.get('invitation_token')
      @model.set(is_client: !@model.get('is_client'))
