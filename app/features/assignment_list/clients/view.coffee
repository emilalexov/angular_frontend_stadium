define [
  './item/view'
  './template'
], (
  ClientItemView
  template
) ->

  class AssignClientsListView extends Marionette.CompositeView

    template: template

    className: 'gc-clients-list-wrapper gc-assign-list'

    childView: ClientItemView

    childViewContainer: 'ul.gc-clients-list'

    childViewOptions: (client) ->
      options =
        assignment: @_getAssigmentBy(client)
        entity: @entity
        clientAssignees: @clientAssignees
      if client.id == App.request('current_user_id')
        options.attributes =
          style: 'background-color: #E3F2FD'
      options

    viewComparator: (model) ->
      if model.get('id') is App.request('current_user_id')
        '1'
      else
        '2' + _.underscored(model.get('full_name'))

    initialize: (options) ->
      @clientAssignees = options.clientAssignees
      @entity = options.entity

    _getAssigmentBy: (user) ->
      @clientAssignees.findWhere
        person_id: user.id
