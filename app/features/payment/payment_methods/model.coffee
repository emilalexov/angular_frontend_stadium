define ->

  class Card extends Backbone.Model

    urlRoot: '/cards'

    defaults:

      object: 'card'
      exp_month: ''
      exp_year: ''
      number: ''
      cvc: ''
      name: ''