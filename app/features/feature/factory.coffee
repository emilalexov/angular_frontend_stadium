define [
  'config'
], (
  config
) ->

  class FeatureFactory

    constructor: (@config) ->
      @

    all: ->
      _.keys(@config)

    includes: (name) ->
      _.chain(@)
        .result('all')
        .includes(name)
        .value()

    isEnabled: (name) ->
      _.chain(@config)
        .result(name)
        .result('enabled')
        .value() || false


  new FeatureFactory(config.features)
