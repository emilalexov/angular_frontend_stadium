define [
  'models/user'
  'collections/assigned_workout_templates_to_client_group'
  'collections/assigned_program_templates_to_client_group'
  './concerns/avatar_background_color'
], (
  User
  AssignedWorkoutTemplates
  AssignedProgramTemplates
  AvatarBackgroundColor
) ->

  class ClientGroup extends Backbone.Model

    type: 'ClientGroup'

    urlRoot: '/client_groups'

    validation:
      name:
        required: true

    constructor: ->
      @clients = new Backbone.Collection
      @workoutTemplates = new AssignedWorkoutTemplates(clientGroup: @)
      @programTemplates = new AssignedProgramTemplates(clientGroup: @)
      super

    initialize: ->
      super
      @_initBgColor()

    updateAvatar: (formData) ->

      options =
        url: "#{@urlRoot}/#{@id}/avatar"
        type: 'PUT'
        data: formData
        processData: false
        contentType: false

      (@sync || Backbone.sync).call(@, null, @, options)
        .then (response) =>
          @trigger 'model:avatar_update:success', response
        .fail (xhr, textStatus, errorThrown) =>
          @trigger 'model:avatar_update:fail', 'Something went wrong'

    addUser: (user) ->
      options =
        url: "#{@url()}/members/#{user.id}"
        type: 'POST'
        data: ''
        processData: false

      request = (@sync || Backbone.sync).call(@, null, @, options)
      request
        .then (response) =>
          @clients.add(user)
          @trigger 'user:add:success', response
        .fail (xhr, textStatus, errorThrown) =>
          @trigger 'user:add:error', arguments
      request

    removeUser: (user) ->
      options =
        url: "#{@url()}/members/#{user.id}"
        type: 'DELETE'
        data: ''
        processData: false

      request = (@sync || Backbone.sync).call(@, null, @, options)
      request
        .then (response) =>
          @clients.remove(user)
          @trigger 'user:remove:success', response
        .fail (xhr, textStatus, errorThrown) =>
          @trigger 'user:remove:error', arguments
      request

    assign: (template) ->
      @_assignment(template, 'assign')

    unassign: (template) ->
      @_assignment(template, 'unassign')

    _assignment: (template, type) ->
      method = if type == 'assign' then 'POST' else 'DELETE'
      options =
        url: "#{@url()}/assignments"
        type: method
        contentType: 'application/json'
        data: JSON.stringify
          template_id: template.id
          template_type: template.constructor::type

      request = (@sync || Backbone.sync).call(@, null, @, options)
      request
        .then (response) =>
          @trigger("template:#{type}:success", response)
        .fail (xhr, textStatus, errorThrown) =>
          @trigger("template:#{type}:fail")
      request

    parse: (data) ->
      if data.clients
        @_parseClients(data.clients) && delete data.clients
      data

    _parseClients: (clients) ->
      currentUser = App.request('current_user')
      clients = _.map clients, (user) ->
        clientCollection = currentUser.clients
        client = clientCollection.get(user.id)
        unless client
          client = new User(user, parse: true)
          clientCollection.add(client)
        client
      @clients.reset(clients)

  _.extend(ClientGroup::, AvatarBackgroundColor)
  ClientGroup
