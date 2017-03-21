define [
  'models/concerns/nested_models'
  './subscription/collection'
  './payment_methods/collection'
  'backbone-nested'
], (
  NestedModelsConcern
  Subscriptions
  Cards
) ->

  class Customer extends Backbone.NestedModel

    url: ->
      user = App.request('current_user')
      "/users/#{user.id}/customer"

    constructor: ->
      @_nestedModelsInit
        subscriptions: Subscriptions
        sources: Cards
      @cards = @sources
      super

    parse: (data) ->
      data.subscriptions = data.subscriptions?.data or []
      data.sources = data.sources?.data or []
      @_nestedModelsParseAll(data)
      data

  _.extend(Customer::, NestedModelsConcern)

  Customer
