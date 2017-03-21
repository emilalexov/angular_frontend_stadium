define [
  './template'
], (
  template
) ->
  class FolderItemView extends Marionette.ItemView

    template: template

    triggers:
      'click .gc-add-modal-folder a': 'folder:clicked'

    templateHelpers: ->
      type: @options.type
      isFolder: !!@model.items