define [
  './empty/view'
  './item/view'
  './template'
], (
  EmptyView
  ItemView
  template
) ->

  class ClientEWPView extends Marionette.CompositeView

    template: template

    className: 'gc-clientpage-exercises row'

    childView: ItemView

    childViewContainer: 'ul'

    emptyView: EmptyView

    filter: (model) ->
      return true if model.type is 'Exercise'
      !model.get('is_program_part') and model.get('status') is 'active'

    emptyViewOptions: ->
      name: @collection.type.split('_')[1]
