define [
  'views/trainer/clients/group-item-view'
  'templates/trainer/clients/group-list'
],
(
  GroupItemView
  template
) ->
  class GroupListView extends Marionette.CompositeView

    template: template

    className: 'gc-clients-list-wrapper gc-assign-list'

    childView: GroupItemView

    childViewContainer: 'ul'
