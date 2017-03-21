define [
  'models/property'
], (
  Property
) ->

  class Properties extends Backbone.Collection

    type: 'Properties'

    model: Property
