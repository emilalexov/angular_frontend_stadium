define ->

  _nestedModelsInit: (data) ->
    @_nestedModels ?= []
    _.chain(data)
      .pairs()
      .each( ([key, klass]) =>
        @_nestedModels.push(key)
        if _.isUndefined(klass.polymorphicKey)
          @[key] = new klass
        else
          @[key] = klass
      )
      .value()

  _nestedModelsParse: (data, namespaces) ->
    _.each namespaces, (namespace) =>
      unless _.isUndefined(data[namespace])
        unless _.isUndefined(@[namespace].polymorphicKey)
          polymorphicKey = data[@[namespace].polymorphicKey]
          @[namespace] = new @[namespace].polymorphicModels[polymorphicKey]
        if _.isFunction(@[namespace].reset)
          @[namespace].reset(data[namespace], parse: true)
        else if _.isFunction(@[namespace].set)
          parsedData = @[namespace].parse(data[namespace])
          @[namespace].set(parsedData)
        delete data[namespace]

  _nestedModelsParseAll: (data) ->
    @_nestedModelsParse(data, @_nestedModels)
