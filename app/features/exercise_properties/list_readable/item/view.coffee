define [
  './template'
], (
  template
) ->

  class ExercisePropertiesListItemReadableView extends Marionette.ItemView

    template: template

    tagName: 'li'

    className: 'gc-property-item'

    behaviors:

      stickit:
        bindings:
          '.gc-property-value-name-label':
            observe: [
              'property_unit_name'
              'value_converted'
              'value2_converted'
            ]
            onGet: ([unit_name, value, value2]) ->
              if value
                "#{_.compact([value, value2]).join(' - ')} #{unit_name}"
              else
                @model.personal_property.get('name')
