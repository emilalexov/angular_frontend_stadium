define [
  './template'
], (
  template
) ->

  class View extends Marionette.ItemView

    template: template

    className: 'gc-privacy-toggle2'

    behaviors:

      stickit:
        bindings: ->
          'input':
            attributes: [
                name: 'checked'
                observe: 'is_public'
            ]

    events:
      'click label': '_togglePrivacy'

    _togglePrivacy: (ev) ->
      ev.preventDefault()
      is_public = !@model.get 'is_public'
      if @options.instantSave
        @model.save 'is_public', is_public, patch: true
      else
        @model.set 'is_public', is_public