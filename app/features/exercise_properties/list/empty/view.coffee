define [
  './template'
], (
  template
) ->

  class ExercisePropertiesEmptyView extends Marionette.ItemView

    template: template

    tagName: 'li'

    className: 'gc-property-item empty'
