define [
  './template'
], (
  template
) ->

  class View extends Marionette.ItemView

    template: template

    className: 'gc-rating-widget'
