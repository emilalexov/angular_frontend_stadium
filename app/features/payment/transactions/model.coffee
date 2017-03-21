define ->

  class Transaction extends Backbone.Model

    defaults:
      id: undefined
      amount: undefined
      amount_refunded: undefined
      created: undefined
      currency: ''
      customer: ''
      description: null
      failure_code: null
      failure_message: null
      metadata: {}
      paid: undefined
      refunded: undefined
      refunds: {}
      source: {}
      status: ''
