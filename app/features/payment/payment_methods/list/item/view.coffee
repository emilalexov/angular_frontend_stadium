define [
  './template'
], (
  template
) ->

  class CardItem extends Marionette.ItemView

    template: template

    className: 'card'

    behaviors: ->

      stickit:
        bindings:
          '.full-name': 'name'
          '.number': 'last4'

    events:
      'click .delete': '_delete'

    _delete: ->
      @model.destroy(wait: true)