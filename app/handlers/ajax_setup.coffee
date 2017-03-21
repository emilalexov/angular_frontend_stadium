define ->

  (App, config) ->

    $(document).ajaxStart ->
      App.vent.trigger('ajax:start', arguments...)

    $(document).ajaxComplete ->
      App.vent.trigger('ajax:complete', arguments...)

    $(document).ajaxError (event, jqxhr, settings, thrownError) ->
      if jqxhr.status is 401
        if 'login' != Backbone.history.fragment
          Backbone.history.navigate('login')
        else
          App.request('messenger:explain', 'login.unauthorized')

      if jqxhr.status is 403
        error = jqxhr.responseJSON.error
        error = error.join(', ') if _.isArray(error)
        message = error.replace( /\s+(\[.+\])/, '')
        App.request 'messenger:explain', 'message.error',
          message: message

      if jqxhr.status is 452
        App.vent.trigger('redirect:to', ['auth', 'waiting_gymcloud_pro'])

      if jqxhr.status is 453
        App.vent.trigger('redirect:to', ['auth', 'pro_invite_reminder'])

      if jqxhr.status is 454
        App.vent.trigger('redirect:to', ['auth', 'client_signup'])

    _.each ['Model', 'Collection'], (namespace) ->
      oldCtr = Backbone[namespace]
      Backbone[namespace]::constructor = ->
        @listenTo @, 'request', ->
          @_isRequested = true
        @listenTo @, 'sync', ->
          @_isRequested = false
          @_isSynced = true
        oldCtr.apply(@, arguments)

    Backbone.originalSync = Backbone.sync
    Backbone.sync = (method, model, options) ->
      options.type = 'PATCH' if method == 'update'
      Backbone.originalSync method, model, options

    $.ajaxSetup
      headers: {'X-Requested-With': 'XMLHttpRequest'}
      contentType: 'application/json'
      crossDomain: true
      xhrFields: withCredentials: true
      beforeSend: (xhr, options) ->
        xhr.withCredentials = true
        options.url = "#{config.api.url}#{options.url}"
        accessToken = App.request('accessToken:get')
        if accessToken
          authorization = "Bearer #{accessToken}"
          xhr.setRequestHeader('Authorization', authorization)
        return
