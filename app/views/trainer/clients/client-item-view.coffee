define [
  'templates/trainer/clients/client-item'
], (
  template
) ->

  class ClientItemView extends Marionette.ItemView

    template: template

    tagName: 'li'

    className: 'row gc-workout-client-item'

    ui:
      deleteSingle: '.gc-clients-list-client-delete'
      moveSingle: '.gc-clients-list-client-move'
      checkbox: 'input[type="checkbox"]'

    events:
      'click @ui.deleteSingle': 'deleteSingle'
      'click @ui.moveSingle': 'moveSingle'

    behaviors:
      stickit:
        model: ->
          @model.user_profile
        bindings:
          '.gc-clients-list-avatar-wrapper':
            classes:
              'gc-clients-list-avatar-exist':
                observe: 'avatar'
                onGet: (value) ->
                  value?.thumb?.url
          '.gc-clients-list-avatar-wrapper':
            attributes: [
              name: 'style',
              observe: 'avatar_background_color',
              onGet: (value) ->
                "background-color: #{value}" if value
            ]
          '.gc-clients-list-client-link':
            observe: [
              'first_name'
              'last_name'
            ]
            onGet: (values) ->
              _.compact(values).join(' ')
          '.gc-clients-list-avatar-wrapper img':
            attributes: [
                name: 'src'
                observe: 'avatar'
                onGet: (value) ->
                  value?.thumb?.url
            ]

    initialize: ->
      App.vent.on 'rm-client', @removeClient

    onDestroy: ->
      App.vent.off 'rm-client', @removeClient

    removeClient: =>
      if @ui.checkbox.is(':checked')
        @model.destroy(wait: true).then =>
          App.request('current_user').clients.remove(@model.id)

    deleteSingle: (ev) =>
      # set name as full name to be recognized by
      # modal:confirm:delete

      @model.set('name', @model.fullName())
      App.request('modal:confirm:delete', @model).then =>
        @model.collection?.remove(@model)
        App.request('current_user').clients.remove(@model.id)

    moveSingle: (ev) =>
      $(ev.currentTarget).closest('.row')
        .find(':checkbox').prop('checked', true)
      @trigger 'individual:move'
