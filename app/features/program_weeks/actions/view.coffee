# NOTE: not used anymore
define [
  './template'
], (
  template
) ->

  class View extends Marionette.LayoutView

    template: template

    className: 'col col-lg-6'

    triggers:
      'click button': 'program_weeks:build'
