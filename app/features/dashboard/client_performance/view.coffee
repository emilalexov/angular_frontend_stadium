define [
  './item/view'
  './template'
], (
  ItemView
  template
) ->

  class ClientPerformanceCollectionView extends Marionette.CompositeView

    template: template

    className: 'tab-content'

    childViewContainer: 'tbody'

    childView: ItemView
