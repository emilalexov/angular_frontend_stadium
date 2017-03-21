define [
  'collections/user_collection'
  './model'
], (
  UserCollection
  TransactionModel
) ->

  class Transactions extends UserCollection

    type: 'transactions'

    model: TransactionModel
