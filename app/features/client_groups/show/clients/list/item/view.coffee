define [
  './template'
], (
  template
) ->

  class MembersItemView extends Marionette.ItemView

    template: template

    tagName: 'li'

    className: 'row padding-0'
