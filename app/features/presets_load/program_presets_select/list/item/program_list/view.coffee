define [
  './item/view'
], (
  ProgramItemView
) ->

  class ProgramListView extends Marionette.CollectionView

    tagName: 'list'

    childView: ProgramItemView
