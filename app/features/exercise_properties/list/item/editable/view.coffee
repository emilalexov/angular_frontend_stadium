define [
  './template'
  'features/properties/select_box/view'
], (
  template
  PropertiesSelectBox
) ->

  class ExercisePropertiesListItemView extends Marionette.LayoutView

    template: template

    tagName: 'li'

    className: 'gc-property-item'

    behaviors:

      editable_exercise_property: true

    ui: ->
      editPropertyControl: '.gc-property'
      savePropertyButton: '.gc-save'

    events: ->
      'focusout': _.debounce(@saveOnBlur, 200)
      'click @ui.savePropertyButton': '_saveProperty'

    initialize: ->
      Backbone.Validation.bind @

    _saveProperty: ->
      unless @model.isValid(true)
        return App.request 'messenger:show',
          type: 'error'
          message: 'Please select a property.'
      @model.save({}, {wait: true}).then =>
        @trigger('edited')
        App.request('messenger:explain', 'exercise.updated')
      .fail ->
        App.request('messenger:explain', 'error.unknown')
      .always =>
        @trigger('switchTo:readable')

    saveOnBlur: (ev) ->
      activeEl = $(':focus')
      if @ui.editPropertyControl.find(activeEl).length is 0
        @_saveProperty()
