define [
  './in_progress.jade'
], (
  template
) ->

  class InProgressView extends Marionette.ItemView

    template: template

    className: 'gc-empty-view-content'
