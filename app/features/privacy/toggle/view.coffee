define [
  './template'
], (
  template
) ->

  class View extends Marionette.ItemView

    template: template

    className: 'btn-group gc-btn-group gc-privacy-toggle'

    attributes: 'data-toggle': 'buttons'

    modelAttribute: 'is_public'

    behaviors:

      stickit:
        bindings: ->
          'label.role-on':
            classes:
              active: @modelAttribute
          'label.role-off':
            classes:
              active:
                observe: @modelAttribute
                onGet: (value) ->
                  not value

    events: ->
      'click label': (ev) ->
        ev.preventDefault()
        value = $(ev.currentTarget).find('input').val() is 'true'
        attrs = {}
        attrs[@modelAttribute] = value
        @model.patch(attrs)
