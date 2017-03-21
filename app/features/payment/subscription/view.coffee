define [
  './template'
], (
  template
) ->

  class Subscription extends Marionette.ItemView

    template: template

    className: 'subscription'

    behaviors: ->

      stickit:
        bindings:
          '.next-payment .bold':
            observe: ['status', 'current_period_end', 'trial_end']
            onGet: ([status, stamp1, stamp2]) ->
              return 'Loading...' unless status
              stamp = if status is 'active' then stamp1 else stamp2
              moment.unix(stamp).format('MMM DD, YYYY')
          '.current .secondary':
            observe: 'plan.name'
            onGet: (name) -> name or 'Loading...'
          '.price':
            observe: 'plan.amount'
            onGet: (cents) ->
              return 'Loading...' unless cents
              amount = _.numberFormat(cents / 100, 2, '.', ',')
              "$ #{amount}"

    initialize: ->
      @model = new @collection.model
      @listenTo @collection, 'reset sync', ->
        current = @collection.current()
        @model.set(current?.attributes)
