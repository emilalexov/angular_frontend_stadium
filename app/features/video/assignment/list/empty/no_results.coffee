define [
  './no_results.jade'
], (
  template
) ->

  class NoResultsView extends Marionette.ItemView

    template: template

    className: 'gc-empty-view-content'
