define ->

  class ClientGroupMember extends Backbone.Model

    urlRoot: ->
      "/client_groups/#{@get('groupId')}/members/#{@get('clientId')}"

    defaults:
      groupId: undefined
      clientId: undefined
