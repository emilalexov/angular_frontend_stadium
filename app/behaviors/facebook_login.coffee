define [
  './social_login'
], (
  SocialLoginBehavior
) ->

  class FacebookLoginBehavior extends SocialLoginBehavior

    key: 'facebook_login'

    _vendorKey: 'app_id'

    _vendorName: 'facebook'

    ui:
      'button': 'span.btn.btn-primary[data-social="fb"]'

    initialize: ->
      ((d, s, id) ->
        return if d.getElementById(id)
        js = d.createElement(s)
        js.id = id
        js.src = '//connect.facebook.net/en_US/sdk.js'
        fjs = d.getElementsByTagName(s)[0]
        fjs.parentNode.insertBefore js, fjs
      ) document, 'script', 'facebook-jssdk'
      window.fbAsyncInit = =>
        FB.init
          appId: @getVendorAppId()
          cookie: true
          xfbml: true
          version: 'v2.2'

    login: ->
      FB.login ((response) =>
        @getToken('facebook', response) if response.authResponse
      ), {
        auth_type: 'rerequest'
        scope: 'email,public_profile'
      }
