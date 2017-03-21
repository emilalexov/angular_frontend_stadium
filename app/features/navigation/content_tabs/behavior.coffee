define [
  'behaviors/base/regioned'
  './view'
], (
  BaseRegionedBehavior
  NavigationContentTabsView
) ->

  class NavigationContentTabsBehavior extends BaseRegionedBehavior

    regionName: 'navigation_content_tabs'

    behaviorViewClass: NavigationContentTabsView

    behaviorViewOptions: ->
      data: @options.data

    defaults: ->
      data: []
      onActivated: undefined

    initialize: ->
      super
      @listenTo(@view, 'show', @_initEvents)

    _initEvents: ->
      _.bindAll @, [
        '_onActivated'
        '_onChangeState'
        '_redirectToSubPath'
      ]...
      @listenTo(@behaviorView, 'activated', @_onActivated)
      @listenTo(@view.model, 'change:state.subpage', @_onChangeState)

    _onActivated: (subPath) ->
      fn = @options.onActivated
      if typeof fn isnt 'function'
        fn = @_redirectToSubPath
      fn(subPath)

    _onChangeState: ->
      state = @view.model.get('state.subpage')
      @behaviorView.trigger('activate', state)

    _redirectToSubPath: (path) ->
      paths = @_getPaths(path)
      if @_shouldBeActivated(path)
        if @view.model.get('state.subpage') isnt paths.dest
          @view.model.set('state.subpage', paths.dest)
        App.vent.trigger 'redirect:to', paths.full,
          replace: true
          trigger: false

    _shouldBeActivated: (path) ->
      paths = @_getPaths(path)
      not paths.same
      true

    _getPaths: (dest) ->
      re = /^(.*)\/(\w*)$/
      match = location.hash.match(re)
      base = match[1]
      sub = match[2]
      full = [base, dest].join('/')
      dest: dest
      base: base
      sub: sub
      same: dest is sub
      full: full
