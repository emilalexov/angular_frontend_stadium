define [
  './template'
], (
  template
) ->

  class View extends Marionette.ItemView

    template: template

    tagName: 'span'

    className: 'btn'

    behaviors:
      stickit:
        bindings:
          ':el':
            classes:
              'btn-success':
                observe: 'is_public'
                onGet: (value) -> value
              'btn-warning':
                observe: 'is_public'
                onGet: (value) -> !value
          'i':
            classes:
              'fa-eye':
                observe: 'is_public'
                onGet: (value) -> value
              'fa-lock':
                observe: 'is_public'
                onGet: (value) -> !value
          'span':
            observe: 'is_public'
            onGet: (value) ->
              value && 'Public' || 'Private'
