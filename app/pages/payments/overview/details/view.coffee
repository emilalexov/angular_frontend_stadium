define [
  './template'
  'features/payment/customer_model'
  'features/payment/subscription/view'
  'features/payment/payment_methods/view'
], (
  template
  Customer
  SubscriptionView
  PaymentMethodsView
) ->

  class PaymentDetailsView extends Marionette.LayoutView

    template: template

    className: 'payment-details'

    behaviors:

      regioned:
        views: [
            region: 'subscription'
            klass: SubscriptionView
            options: ->
              collection: @model.subscriptions
          ,
            region: 'payment_methods'
            klass: PaymentMethodsView
            options: ->
              collection: @model.cards
        ]


    initialize: ->
      @model = new Customer
      @model.fetch()
