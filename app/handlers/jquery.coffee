define [
  'jquery'
  'underscore'
], (
  $
  _
) ->

  handlers =

    falseLinks: ->
      selector = [
        "a:not('[href]')"
        '[href="#"]'
      ].join(', ')
      $(document)
        .on 'click', selector, (event) ->
          event.preventDefault()
          false

    navBarShadow: ->
      manageShadow = (event) ->
        if $(event.target).hasClass('gc-workspace-content')
          scroll = $(event.target).scrollTop()
          if scroll >= 10
            $('.gc-nav-wrapper').addClass('gc-nav-shadow')
          else
            $('.gc-nav-wrapper').removeClass('gc-nav-shadow')
      throttledManageShadow = _.throttle(manageShadow, 300)
      document.addEventListener 'scroll', throttledManageShadow, true

    falseForms: ->
      selector = [
        "form:not('[action]')"
      ].join(', ')
      document
        .addEventListener 'submit', (event) ->
          el = $(event.target)
          if el.is(selector)
            event.preventDefault()
            false
          else
            true

  ->
    _.each handlers, (fn) -> fn()
