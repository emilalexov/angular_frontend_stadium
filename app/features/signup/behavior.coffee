define ->

  class AuthBodyClassBehavior extends Marionette.Behavior

    events:
      'click a[href="#login"]': '_removeToken'

    initialize: ->
      @body = $('body')

    onShow: ->
      @body.addClass('auth')

    onDestroy: ->
      @body.removeClass('auth')

    _removeToken: ->
      App.request('accessToken:remove')
