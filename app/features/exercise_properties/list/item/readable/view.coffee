define [
  'features/exercise_properties/list_readable/item/view'
  './template'
], (
  ReadableItemView
  template
) ->

  class ExercisePropertiesListItemReadableView extends ReadableItemView

    template: template

    ui: ->
      removePropertyButton: '.gc-remove'
      toggleEditMode: '.gc-toggle-edit-mode'

    events: ->
      'click @ui.removePropertyButton': 'removeProperty'
      'click @ui.toggleEditMode': 'toggleEditMode'

    toggleEditMode: (ev) ->
      ev.preventDefault()
      @trigger('switchTo:editable')

    removeProperty: (ev) ->
      ev.preventDefault()
      ev.stopImmediatePropagation()
      @model.destroy(wait: true)
