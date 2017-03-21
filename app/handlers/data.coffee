define ->

  (App) ->

    App.data = {}

    App.reqres.setHandler 'data:all:clear', ->
      App.data = {}

    App.reqres.setHandler 'data:personal_properties:visible', ->
      App.data.properties_visible ||=
        new Backbone.VirtualCollection(
          App.request('current_user').personal_properties,
          filter:
            is_visible: true
        )

    App.reqres.setHandler 'data:properties:reset', (properties) ->
      App.data.properties = properties

    App.reqres.setHandler 'lastHash:get', ->
      App.data.lastHash

    App.reqres.setHandler 'lastHash:set', (params) ->
      App.data.lastHash =
        hash: params.hash
        action: params.name

    App.reqres.setHandler 'data:delete', (category, key) ->
      items = App.data[category]
      deleteFromTree = (items, key) ->
        for item, index in items
          if item.isFolder
            deleteFromTree item.items, key
          else if item.key is key
            items.splice index, 1
            return
      deleteFromTree items, key
