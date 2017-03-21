define ->

  class ClientGroup extends Backbone.Model

    type: 'ClientGroup'

    defaults:
      client_ids: []
      client_group_ids: []

    urlRoot: '/client_groups'

    toggleAssign: ->
      actionType = if @get('isAssigned') then 'unassign' else 'assign'
      @set('client_group_ids', [@get('id')])

      options =
        url: @url(actionType)
        data:
          JSON.stringify
            client_ids: @get 'client_ids'
            client_group_ids: @get 'client_group_ids'

      options = App.request 'ajax:options:create', options

      (@sync || Backbone.sync).call(@, null, @, options)
        .then (response) =>
          @set('isAssigned', !@get('isAssigned'))
          @trigger 'model:toggle_assign:success', response, actionType
        .fail (xhr, textStatus, errorThrown) =>
          @trigger 'model:toggle_assign:fail', 'Something went wrong'

  class ClientGroups extends Backbone.Collection

    type: 'ClientGroups'

    model: ClientGroup

    url: '/users'
