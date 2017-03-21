define [
  './template'
  './item/view'
], (
  template
  ItemView
) ->

  class MissedWorkoutEventsView extends Marionette.CompositeView

    template: template

    className: 'tab-content'

    childView: ItemView

    childViewContainer: 'tbody'
