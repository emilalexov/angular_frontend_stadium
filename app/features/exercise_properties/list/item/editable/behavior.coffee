define [
  'features/properties/select_box/view'
  'features/property_unit_selector/view'
], (
  PropertiesSelectBox
  PropertyUnitSelectorCollectionView
) ->

  class EditableExercisePropertyBehavior extends Marionette.Behavior

    key: 'editable_exercise_property'

    behaviors:

      regioned:
        views: [
            region: 'properties_select_box'
            klass: PropertiesSelectBox
            options: ->
              property = if @model.isNew()
                name: 'Property'
                global_property:
                  unit: ''
              else
                @model.get('personal_property')

              default_property: property
          ,
            region: 'property_unit_selector'
            klass: PropertyUnitSelectorCollectionView
            options: ->
              units = if @model.isNew()
                []
              else
                @model.personal_property.property_units.models
              @_property_units.reset(units)

              collection: @_property_units
              selected: @model.get('property_unit_id')
        ]

      stickit:
        bindings:
          '.gc-property-value':
            observe: ['value_converted', 'value2_converted']
            onGet: ([value, value2]) ->
              _.chain([value, value2]).compact().join('-').value()
            onSet: (input) ->
              input.split(/\-+/)

    ui:
      removeButton: '.gc-remove'
      value: '.gc-property-value'

    events:
      'click @ui.removeButton': '_removeProperty'
      'keypress @ui.value': '_handleKeyPress'
      'paste @ui.value': '_handlePaste'

    initialize: ->
      @view._properties = App.request('data:personal_properties:visible')
      @view._property_units = new Backbone.Collection

    onShow: ->
      @listenTo(@view.views.properties_select_box, 'selected', @selectProperty)
      @listenTo(@view.views.property_unit_selector, 'selected', @selectUnit)
      @_selectValue()

    selectUnit: (property_unit) ->
      @view.model.setUnit(property_unit)
      @_selectValue()

    selectProperty: (model) ->
      @view.model.setProperty(model)
      unitSelector = @view.views.property_unit_selector
      defaultUnitId = @view.model.get('property_unit_id')
      units = model.property_units.models
      unitSelector.updateUnits(units, defaultUnitId)
      _.chain(unitSelector.showTooltip).bind(unitSelector).delay(0)
      @_selectValue()

    _removeProperty: (ev) ->
      ev.preventDefault()
      ev.stopImmediatePropagation()
      @view.model.destroy(wait: true)

    _selectValue: ->
      @ui.value.focus()
      setTimeout =>
        @ui.value.selectText()
      , 100

    _handlePaste: (ev) ->
      ev.preventDefault()
      data = ev.clipboardData ||
        ev.originalEvent.clipboardData ||
        window.clipboardData
      [value, value2] = data
        .getData('text')
        .replace(/[^\d\-]/ig, '')
        .split(/\s*\-\s*/)
      @view.model.set
        value: value
        value2: value2
      false

    _handleKeyPress: (ev) ->
      @_saveOnEnter(ev) or @_typeAllowedChars(ev)

    _saveOnEnter: (ev) ->
      if ev.which is 13
        ev.preventDefault()
        @view._saveProperty()
        false

    _typeAllowedChars: (ev) ->
      key = ev.keyCode || ev.which
      char = String.fromCharCode(key)
      currentValue = $(ev.currentTarget).text()

      if key in [8..46]
        return true
      else if not @_inputValuesLengthIsValid(currentValue)
        return false
      else if char.match(/[\-]/) and not currentValue.match(/[\d]+/)
        return false
      else if char.match(/[\-]/) and currentValue.match(/[\-]+/)
        return false
      if not char.match(/[\d\-]/i)
        return false

    _inputValuesLengthIsValid: (text) ->
      _.all text.split(/\s*\-\s*/), (value) ->
        value.length <= 4
