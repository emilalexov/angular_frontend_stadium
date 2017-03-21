define [
  './concerns/nested_models'
  'collections/property_units'
  'backbone-nested'
], (
  NestedModelsConcern
  PropertyUnits
) ->

  class PersonalProperty extends Backbone.NestedModel

    type: 'PersonalProperty'

    urlRoot: '/personal_properties'

    constructor: ->
      @_nestedModelsInit
        property_units: PropertyUnits
      super

    parse: (data) ->
      @_nestedModelsParseAll(data)
      data

  _.extend(PersonalProperty::, NestedModelsConcern)

  PersonalProperty
