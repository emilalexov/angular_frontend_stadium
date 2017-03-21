define [
  'views/trainer/clients/client-item-view'
  'templates/trainer/clients/client-list'
], (
  ClientItemView
  template
) ->
  class ClientListView extends Marionette.CompositeView

    template: template

    className: 'gc-clients-list-wrapper gc-assign-list'

    childView: ClientItemView

    childViewContainer: 'ul'

    childEvents:
      'individual:move': 'moveClient'

    moveClient: =>
      @trigger 'individual:move'

    viewComparator: (model) ->
      name = model.get('name') ||
        model.get('user_profile.full_name')
      _.underscored(name)

    initialize: (options) ->
      MyId = App.request('current_user_id')
      @collection = new Backbone.VirtualCollection options.collection,
        filter: (model) -> MyId != model.get('id')
