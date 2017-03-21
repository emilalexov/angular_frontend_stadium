define [
  './template'
  './item/view'
  'models/personal_property'
], (
  template
  ItemView
  PersonalProperty
) ->

  class PropertiesSelectBoxView extends Marionette.CompositeView

    className: 'gc-properties-select_box btn-group'

    attributes:
      role: 'group'

    template: template

    childView: ItemView

    childViewContainer: 'ul'

    childEvents:
      'selected': 'triggerOptionSelected'

    behaviors:
      stickit:
        bindings:
          '.gc-selected-property': 'name'

    initialize: ->
      @collection = App.request('data:personal_properties:visible')
      property = @options.default_property || @collection.first()?.attributes
      @model = new PersonalProperty(property)

    triggerOptionSelected: (childView) ->
      @model.set(childView.model.attributes)
      @trigger('selected', childView.model)
