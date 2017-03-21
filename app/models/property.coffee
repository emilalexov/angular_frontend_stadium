define [
  'backbone-nested'
], ->

  class Property extends Backbone.NestedModel

    type: 'Property'

    urlRoot: '/properties/'

    validation:

      name:
        required: true

      defaultvalue: (val, attr, computed) ->
        if !val.length
          return
        valueType = computed.value_type
        if valueType == 'Numeric'
          Backbone.Validation.validators
            .pattern(val, attr, 'digits', @)
