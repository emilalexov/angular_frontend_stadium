define [
  './list/view'
  './autocomplete/options'
  './template'
], (
  MembersCollectionView
  autocompleteOptions
  template
) ->
  class MembersView extends Marionette.LayoutView

    template: template

    behaviors: ->

      regioned:
        views: [
            region: 'list'
            klass: MembersCollectionView
            options: -> @options
        ]

      auto_complete: autocompleteOptions

    events:
      'submit @ui.removeForm': 'submitRemoveClient'

    ui:
      rmAssign: '.gc-exercises-assign-btn-del'
      removeModal: '#gc-remove-from-group-modal'
      checked: 'input[type=checkbox]:checked'
      removeForm: '.gc-remove-from-group-form'

    initialize: ->
      @listenTo(@, 'nav:delete', @showRemoveClient)
      @autocompleteCollection = new Backbone.Collection
      @listenTo(@collection, 'reset', _.bind(@_refreshAutocomplete, @))

    onShow: @_refreshAutocomplete

    _refreshAutocomplete: ->
      user = App.request('current_user')
      models = user.clients.filter((client) => !@collection.get(client.id))
      @autocompleteCollection.reset(models)

    showRemoveClient: (ev) =>
      @ui.removeModal.modal 'show'

    submitRemoveClient: (ev) ->
      currentUser = App.request('current_user')
      clientCollection = currentUser.clients

      for check in @$el.find('input[type=checkbox]:checked')
        id = $(check).data('id')
        user = clientCollection.get(id)
        @model
          .removeUser(user)
          .done(_.bind(@_refreshAutocomplete, @))
          .done =>
            App.vent.trigger 'mixpanel:track',
              'client_group_member_removed', @model,
              user_id: user.get('id')

      @ui.removeModal.modal 'hide'

    addMember: (item) ->
      currentUser = App.request('current_user')
      clientCollection = currentUser.clients
      user = clientCollection.get(item.id)
      @model
        .addUser(user)
        .done(_.bind(@_refreshAutocomplete, @))
        .done =>
          App.vent.trigger 'mixpanel:track',
            'client_group_member_added', @model,
            user_id: user.get('id')
