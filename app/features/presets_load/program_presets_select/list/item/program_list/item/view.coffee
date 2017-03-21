define [
  './template.jade'
], (
  template
) ->

  class ProgramItemView extends Marionette.ItemView

    template: template

    className: 'program'

    behaviors: ->

      stickit:
        bindings:
          ':el':
            classes:
              active: 'is_selected'
          '.name': 'name'
          'input':
            observe: 'is_selected'
            attributes: [
                observe: 'id'
                name: 'id'
                onGet: -> @cid
            ]
          'label':
            attributes: [
                observe: 'id'
                name: 'for'
                onGet: -> @cid
            ]

    triggers: 'click input, label':
      event: 'checkbox:clicked'
      preventDefault: false
      stopPropagation: true
