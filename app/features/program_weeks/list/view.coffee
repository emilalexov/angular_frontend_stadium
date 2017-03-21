define [
  './item/view'
], (
  ItemView
) ->

  class ProgramWeeksListView extends Marionette.CollectionView

    className: 'gc-programs-weeks-list-container'

    childView: ItemView

    viewComparator: (model) ->
      model.get('position')
