define [
  './template'
], (
  template
) ->

  class NoTransactions extends Marionette.ItemView

    template: template

    className: 'no-transactions'
