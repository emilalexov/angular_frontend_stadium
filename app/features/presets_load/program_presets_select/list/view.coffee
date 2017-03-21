define [
  './item/view'
  './collection'
], (
  ProgramPresetItemView
  ProgramPresetsCollection
) ->
  class ProgramPresetListView extends Marionette.CollectionView

    tagName: 'ul'

    className: 'presets'

    childView: ProgramPresetItemView

    initialize: ->
      @collection = new ProgramPresetsCollection
      @collection.fetch()
