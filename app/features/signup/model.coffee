define [
  'models/auth/login-model'
], (
  LoginModel
) ->

  class AccountModel extends Backbone.Model

    urlRoot: '/users.json'

    defaults:
      first_name: undefined
      last_name: undefined
      email: undefined
      password: undefined
      password_confirmation: undefined
      user_profile_id: undefined
      is_client: false

    validation:

      first_name:
        required: true

      last_name:
        required: true

      email:
        required: true
        pattern: 'email'

      password:
        required: true
        minLength: 6
        msg: 'Password must be 6 characters'

      password_confirmation: [
          equalTo: 'password'
          msg: 'The passwords do not match'
        ,
          required: true
          minLength: 6
          msg: 'Password must be 6 characters'
      ]

      agree:
        acceptance: true

    createAccount: ->
      defer = new $.Deferred

      unless @isValid true
        setTimeout (-> defer.reject()), 1
        return defer.promise()

      $.post('/users.json', JSON.stringify(@_prepareInitialParams()))
        .then (user) =>
          # set created id and user_profile_id
          @set('id', user.id)
          @set('user_profile_id', user.user_profile.id)

          # get the token once the account is created
          loginModel = new LoginModel
            username: @get('email')
            password: @get('password')

          loginModel.once 'model:login:success', (response) =>
            defer.resolve()
            App.request 'accessToken:set', response.access_token
            App.request('current_user').fetch()

            # update user profile once access token is received
            @_updateUserProfile @get('user_profile_id'), (profileResponse) =>
              @trigger('account:created', response, profileResponse)

          loginModel.login()

        .fail (xhr, settings, errorThrown)  ->
          errorJSON = xhr.responseJSON.error
          for key of errorJSON
            if errorJSON.hasOwnProperty(key)
              errorMsg = "#{key} #{errorJSON[key].join(',')}"
            break

          App.request 'messenger:explain', 'message.error',
            message: errorMsg

      defer.promise()

    acceptInvite: ->
      if @isValid true
        $.ajax(
          url: '/users/invitation.json'
          data: JSON.stringify(@_prepareInviteParams())
          type: 'PUT'
        ).then (response) =>
          # get the token once the account is created
          loginModel = new LoginModel
            username: @get('email')
            password: @get('password')

          loginModel.once 'model:login:success', (response) =>
            App.request('accessToken:set', response.access_token)
            App.request('current_user').fetch()

            # update user profile once access token is received
            @_updateUserProfile @get('user_profile_id'), =>
              @trigger('account:created', response)

          loginModel.login()

    # Initial request payload should only include
    # email and password
    _prepareInitialParams: ->
      user: _.pick(@attributes, 'email', 'password', 'is_client')

    # once account is created, update user_profile
    _preparePatchParams: ->
      params = _.pick(@attributes, 'first_name', 'last_name')

      # rename proper keys for user_profile request
      params.user_id = @get('id')
      params.id = @get('user_profile_id')
      params

    _prepareInviteParams: ->
      params = @_prepareInitialParams()
      params.user.invitation_token = @get('invitation_token')
      params

    # update user profile using patch
    _updateUserProfile: (user_profile_id, doneCallback) =>
      $.ajax
        url: "/user_profiles/#{user_profile_id}"
        data: JSON.stringify(@_preparePatchParams())
        type: 'PATCH'
      .then(doneCallback)
