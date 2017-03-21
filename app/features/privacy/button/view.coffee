define [
  './template'
], (
  template
) ->

  class View extends Marionette.ItemView

    template: template

    tagName: 'button'

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
          'span':
            observe: 'is_public'
            onGet: (value) ->
              value && 'Public' || 'Private'

    events:
      'click': '_changePrivacy'

    _changePrivacy: ->
      @model.patch
        is_public: !@model.get('is_public')
