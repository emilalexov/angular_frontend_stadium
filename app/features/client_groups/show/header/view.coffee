define [
  './template'
], (
  template
) ->

  class ClientGroupHeaderView extends Marionette.ItemView

    id: 'client-header-region'

    template: template

    behaviors:

      stickit:
        bindings:
          '.gc-usercard-name': 'name'
          '.gc-usercard-avatar-wrapper':
            classes:
              'gc-usercard-avatar-exist':
                observe: 'avatar_url'
          '.gc-usercard-avatar':
            attributes: [
                name: 'src'
                observe: 'avatar_url'
            ]
          'input.gc-usercard-link':
            observe: 'id'
            onGet: (value) ->
              loc = window.location
              "#{loc.protocol}//#{loc.host}/#client_groups/#{value}"

    events:
      'click .show-client-form': '_showEditModal'

    _showEditModal: (ev) ->
      App.request('modal:groups', @model)
