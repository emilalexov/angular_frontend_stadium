define [
  './template'
], (
  template
) ->

  class NewExerciseResultItemView extends Marionette.ItemView

    className: 'input-wrapper'

    template: template

    behaviors: ->

      stickit:

        bindings:
          'input':
            observe: 'value_converted'
            events: ['blur', 'change']
          'label':
            observe: ['personal_property', 'property_unit_name']
            onGet: ([property, units]) ->
              toDisplay = [property.name]
              if @model.personal_property.property_units.length > 1
                toDisplay.push(units)
              toDisplay.join(', ')
