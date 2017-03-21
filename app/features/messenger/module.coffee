define [
  'exports?Messenger!messenger'
  './template'
  './explain'
], (
  Messenger
  template
  explain
) ->

  class Message extends Messenger.Message

    template: (opts) ->
      t = template
        type: opts.type
        message: opts.message
      $(t)

  Messenger.themes.gymcloud =
    Message: Message

  Messenger.options =
    theme: 'gymcloud'
    extraClasses: 'messenger-fixed messenger-on-top messenger-on-right'

  class Module extends Marionette.Module

    initialize: ->

      @on 'start', ->
        @_initHandlers()

    _initHandlers: ->

      # data.type: 'info', 'success', 'error'
      @app.reqres.setHandler 'messenger:show', (data) ->
        Messenger().post
          message: data.message
          type: data.type ?= 'info'
          hideAfter: data.hideAfter ?= 5

      @app.reqres.setHandler 'messenger:explain', (key, attrs = {}) =>
        @app.request('messenger:show', explain(key, attrs))
