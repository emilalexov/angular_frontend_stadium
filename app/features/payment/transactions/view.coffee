define [
  './item/view'
  './empty/view'
], (
  TransactionsItem
  NoTransactions
) ->

  class TransactionsList extends Marionette.CollectionView

    tagName: 'list'

    childView: TransactionsItem

    emptyView: NoTransactions
