define [
  './template'
], (
  template
) ->

  class TrialEndedView extends Marionette.ItemView

    template: template

    className: 'page-wrap payment-page'

    onShow: ->
      $('body').attr('class', 'auth')

    onDestroy: ->
      $('body').removeClass('auth')
