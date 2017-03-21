define [
  './social_login'
], (
  SocialLoginBehavior
) ->

  class GoogleLoginBehavior extends SocialLoginBehavior

    key: 'google_login'

    _vendorKey: 'client_id'

    _vendorName: 'google'

    ui:
      'button': 'span.btn.btn-danger[data-social="gplus"]'

    initialize: ->
      $.ajax
        url: 'https://apis.google.com/js/client:plus.js'
        dataType: 'script'
        cache: true
        beforeSend: -> # don't add our domain to url

    login: ->
      window.gapi?.auth.authorize {
        immediate: false
        response_type: 'code'
        cookie_policy: 'single_host_origin'
        client_id: @getVendorAppId()
        scope: 'email profile'
      }, (response) =>
        if response and !response.error
          @getToken('google_oauth2', response)
        else
          # google authentication failed
