define [
  './template'
], (
  template
) ->

  class PropertiesItemView extends Marionette.ItemView

    template: template

    tagName: 'li'

    className: 'row gc-properties-list-item'

    events:
      'change .switch input': 'switchProperty'

    switchProperty: (ev) ->
      state = ev.currentTarget.checked
      @model.save(is_visible: state)
