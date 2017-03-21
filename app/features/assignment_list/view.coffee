define [
  './clients/view'
  './groups/view'
  './template'
], (
  AssignClientsListView
  AssignGroupsListView
  template
) ->

  class AssignView extends Marionette.LayoutView

    template: template

    behaviors:
      regioned:
        views: [
            region: 'clients'
            klass: AssignClientsListView
            options: ->
              collection: App.request('current_user').clients
              clientAssignees: @model.assignees
              entity: @model
          ,
            region: 'groups'
            klass: AssignGroupsListView
            options: ->
              collection: @model.group_assignments
              entity: @model
        ]
