define [
  './template'
], (
  template
) ->

  class View extends Marionette.ItemView

    tagName: 'label'

    className: 'btn btn-primary'

    template: template

    behaviors:
      stickit:
        bindings:
          'input':
            attributes: [
              name: 'value'
              observe: 'value'
            ]
          'span': 'name'

    onRender: ->
      @_markAsActive()

    _markAsActive: ->
      if @model.get('inScope')
        @el.classList.add 'active'
