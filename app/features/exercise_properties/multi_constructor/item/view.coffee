define [
  'features/properties/select_box/view'
  './template'
], (
  PropertiesSelectBox
  template
) ->

  class WorkoutExercisePropertyItem extends Marionette.LayoutView

    template: template

    tagName: 'li'

    className: 'pull-left'

    behaviors:

      editable_exercise_property: true

    events:
      'click .gc-property-value-container' : '_selectValue'

    _saveProperty: -> # no need to save
