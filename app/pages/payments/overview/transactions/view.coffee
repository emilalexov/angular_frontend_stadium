define [
  './template'
  'features/payment/transactions/view'
], (
  template
  TransactionsList
) ->

  class TransactionsView extends Marionette.LayoutView

    template: template

    className: 'transactions'

    ui:
      header: '.transactions-header'

    behaviors:

      regioned:
        views: [
            region: 'transactions'
            klass: TransactionsList
            options: ->
              collection: @collection
        ]

    initialize: ->
      @listenTo @collection, 'sync', =>
        if @collection.isEmpty()
          @ui.header.hide()
        else
          @ui.header.show()
