define [
  'config'
], (
  config
) ->

  class SocialLoginBehavior extends Marionette.Behavior

    key: 'social_login'

    _vendorKey: 'trainer_id'

    _vendorName: 'gymcloud'

    events:
      'click @ui.button': 'login'

    login: (e) ->
      throw('Not Implemented')

    getToken: (provider, resp) ->
      resp['is_signup'] = @options.isSignup
      resp['is_linking'] = @options.isLinking
      if @options.isLinking
        successCallback = @options.successCallback
      else
        successCallback = @successCallback
      data = JSON.stringify _.omit(resp, 'g-oauth-window')
      $.ajax
        type: 'POST'
        url: "/users/auth/#{provider}/callback"
        dataType: 'json'
        contentType: 'application/json'
        data: data
        xhrFields: withCredentials: true
        success: successCallback
        error: (error) ->
          if error.status is 404
            App.request('messenger:explain', 'login.abscent')
          else
            App.request('messenger:explain', 'login.failed')
      false

    getVendorAppId: ->
      vendor = config.vendor[@_vendorName]
      vendor?[@_vendorKey] || throw('Not Implemented')

    successCallback: (json) ->
      App.request('auth:onSuccess', json)
