define [
  'templates/trainer/clients/group-item'
],
(
  template
) ->
  class GroupItemView extends Marionette.ItemView

    template: template

    tagName: 'li'

    className: 'row gc-workout-client-item'

    modelEvents:
      sync: 'render'
      change: 'render'

    ui:
      deleteSingle: '.gc-clients-list-client-delete'
      checkbox: 'input[type="checkbox"]'

    initialize: ->
      App.vent.on 'rm-group', @removeGroup

    onDestroy: ->
      App.vent.off 'rm-group', @removeGroup

    events:
      'click @ui.deleteSingle': 'deleteSingle'

    removeGroup: =>
      if @ui.checkbox.is(':checked')
        @model.destroy()

    deleteSingle: (ev) =>
      App.request('modal:confirm:delete', @model)
