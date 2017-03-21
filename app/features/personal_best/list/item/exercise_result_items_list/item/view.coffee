define [
  './template'
], (
  template
) ->

  class ResultItemView extends Marionette.LayoutView

    className: 'result-item'

    template: template

    behaviors:

      stickit:
        bindings:
          '.value':
            observe: 'value_converted'
            onGet: (value) ->
              units = @model.exercise_property.get('property_unit_name')
              "#{value} #{units}"
