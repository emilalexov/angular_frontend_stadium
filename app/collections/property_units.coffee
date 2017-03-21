define [
  'models/property_unit'
], (
  PropertyUnit
) ->

  class PropertyUnits extends Backbone.Collection

    type: 'PropertyUnits'

    model: PropertyUnit

    comparator: 'id'
