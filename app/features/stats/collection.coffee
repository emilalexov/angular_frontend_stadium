define ->

  class Stats extends Backbone.Collection

    symbols:
      client: [
        'personal_workouts'
        'personal_programs'
      ]
      pro: [
        'clients'
        'client_groups'
        'exercises'
        'workout_templates'
        'program_templates'
      ]

    build: (user) ->
      symbols = if user.get('is_pro') then @symbols.pro else @symbols.client
      data = _.chain(symbols)
        .select((symbol) ->
          user[symbol] instanceof Backbone.Collection
        )
        .map((symbol) =>
          {
            symbol: symbol
            collection: user[symbol]
            count: count = @_getCountBySymbol(symbol, user)
            title: @_getTitleBySymbol(symbol, count, user)
            path: @_getPathBySymbol(symbol, user)
          }
        )
        .value()
      @reset(data)

      @each (model) =>
        collection = model.get('collection')
        symbol = model.get('symbol')
        @listenTo collection, 'add remove reset', =>
          model.set
            count: collection.length
            title: @_getTitleBySymbol(symbol, collection.length, user)

    _getCountBySymbol: (symbol, user) ->
      if symbol is 'clients'
        clients = user[symbol].filter (client) ->
          client.id isnt user.id
        return clients.length
      user[symbol].length

    _getTitleBySymbol: (symbol, count, user) ->
      symbol = user.user_settings.get('clients_title') if symbol is 'clients'
      _.chain(symbol)
        .humanize()
        .singularize()
        .pluralize(count)
        .value()

    _getPathBySymbol: (symbol, user) ->
      _.result({
        clients: ->
          '#clients/individuals'
        client_groups: ->
          '#clients/groups'
        exercises: =>
          id = @_getRootFolderId('Exercises', user)
          "#exercises_folder/#{id}"
        workout_templates: =>
          id = @_getRootFolderId('Workout Templates', user)
          "#workout_templates_folder/#{id}"
        program_templates: =>
          id = @_getRootFolderId('Program Templates', user)
          "#program_templates_folder/#{id}"
        workout_exercises: ->
          '#workout_exercises'
        personal_workouts: ->
          '#personal_workouts'
        personal_programs: ->
          '#personal_programs'
      }, symbol) || '#'

    _getRootFolderId: (name, user) ->
      user.folders.findWhere(name: name).get('id')
