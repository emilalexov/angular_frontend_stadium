define [
  './item/view'
  './template'
], (
  GroupItemView
  template
) ->

  class AssignGroupsListView extends Marionette.CompositeView

    template: template

    className: 'gc-clients-list-wrapper gc-assign-list'

    childView: GroupItemView

    childViewContainer: 'ul.gc-clients-list'

    childViewOptions: ->
      entity: @entity

    viewComparator: (model) ->
      _.underscored(model.get('name'))

    initialize: (options) ->
      @entity = options.entity
