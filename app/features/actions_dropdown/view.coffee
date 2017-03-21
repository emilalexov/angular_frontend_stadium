define [
  './template'
  './item/view'
  './collection'
], (
  template
  ItemView
  Collection
) ->

  class View extends Marionette.CompositeView

    template: template

    className: 'gc-program-actions'

    childView: ItemView

    childEvents:
      'action': '_triggerAction'

    childViewContainer: 'ul'

    initialize: ->
      @collection = new Collection(@options.items)

    _triggerAction: (childView) ->
      action = childView.model.get('action')
      _.bind(action, @)() if _.isFunction(action)
