define ->

  class StickitBehavior extends Marionette.Behavior

    key: 'stickit'

    onShow: ->
      @_initArgs()
      @view.stickit(@args.model, @args.bindings)

    onDestroy: ->
      unless _.isUndefined(@args)
        @view.unstickit(@args.model, @args.bindings)

    _initArgs: ->
      @args ?= {}
      @_initArg('model')
      @_initArg('bindings')

    _initArg: (name) ->
      unless _.isUndefined(@options[name])
        @args[name] = @options[name]
      else
        @args[name] = @view[name]
      if _.isFunction(@args[name])
        fn = @args[name].bind(@view)
        @args[name] = fn()