define [
  './template'
], (
  template
) ->

  class TransactionsItem extends Marionette.ItemView

    template: template

    className: 'transactions-item'

    behaviors: ->

      stickit:
        bindings:
          '.date':
            observe: 'created'
            onGet: (stamp) ->
              moment.unix(stamp).format('DD MMM YYYY')
          '.description': 'description'
          '.amount':
            observe: 'amount'
            onGet: (cents) ->
              amount = _.numberFormat(cents / 100, 2, '.', ',')
              "$#{amount}"
          '.status i.gc-status-icon':
            classes:
              'gc-status-cancel':
                observe: 'status'
                onGet: (status) ->
                  status isnt 'succeeded'
