define [
  './template'
  'config'
], (
  template
  config
) ->

  class AddCardView extends Marionette.ItemView

    template: template

    tagName: 'form'

    className: 'payment-info'

    attributes:
      role: 'form'

    behaviors: ->

      stickit:
        bindings:
          '.full-name': 'name'
          '.number': 'number'
          '.exp_month': 'exp_month'
          '.exp_year': 'exp_year'
          '.cvc': 'cvc'

    events:
      'click button[type="submit"]': '_cardAdded'

    initialize: ->
      @_initStripe()

    _initStripe: ->
      return if window.Stripe
      $.ajax
        url: 'https://js.stripe.com/v2/'
        dataType: 'script'
        async: true
        beforeSend: -> # don't add our domain to url
        success: ->
          key = config.vendor.stripe.publishable_key
          window.Stripe.setPublishableKey(key)

    _cardAdded: (ev) ->
      ev.preventDefault()
      attributes = @model.toJSON()
      callback = _.bind(@_stripeResponseHandler, @)
      window.Stripe.card.createToken(attributes, callback)

    _stripeResponseHandler: (status, response) ->
      if response.error
        App.request 'messenger:show',
          type: 'error'
          message: response.error.message
      else
        attrs = _.extend({}, response.card, id: response.id)
        @model.patch(attrs)
          .then (cardResponse) =>
            @trigger('card:added', cardResponse)
            @model.clear()
          .fail (error) ->
            App.request 'messenger:show',
              type: 'error'
              message: error.responseJSON.error
