define [
  './template'
], (
  template
) ->

  class HeaderView extends Marionette.LayoutView

    template: template

    className: 'gc-topbar'

    regions:
      searchBar: 'region[data-name="search-bar"]'

    behaviors:
      stickit:
        bindings:
          '.client-title':
            observe: 'id'
            onGet: ->
              @model.user_settings.get('clients_title')
          '.is_pro':
            observe: 'is_pro'
            visible: true
          '.is_client':
            observe: 'is_pro'
            visible: (value) -> !value
          '.gc-topbar-avatar a':
            classes:
              'presents':
                observe: 'user_profile.avatar.thumb.url'
            attributes: [
                name: 'title'
                observe: [
                  'user_profile.first_name'
                  'user_profile.last_name'
                ]
                onGet: (values) ->
                  _.compact(values).join(' ')
            ]
          '.gc-topbar-avatar img':
            attributes: [
                name: 'src'
                observe: 'user_profile.avatar.thumb.url'
            ]
          '[data-feature="refer_friend"]':
            observe: 'id'
            visible: ->
              feature.isEnabled('refer_friend')

    events:
      'click [refer-friend]': '_referFriend'

    initialize: ->
      @listenTo(App.vent, 'profile:ready', @render)
      @model = App.request('current_user')

    onBeforeRender: ->
      @model.set(App.request('current_user').attributes)

    onRender: ->
      @$('img').on('error', @_onImgError)
      App.vent.trigger('app:view:header:render', @)

    onDestroy: ->
      App.vent.trigger('app:view:header:destroy', @)

    _onImgError: =>
      @model.set('user_profile.avatar.url', undefined)

    _referFriend: ->
      App.request 'modal:prompt',
        title: 'Refer a friend'
        description: '''Share GymCloud with your friends!
                        Invite another fitness pro to join us.'''
        label: 'Email'
        input_type: 'email'
        confirmBtn: 'SEND INVITATION'
        confirmCallBack: (str) ->
          creation = $.ajax
            url: '/pros'
            type: 'POST'
            dataType: 'json'
            data: JSON.stringify(email: str)
          creation.then ->
            $.ajax
              url: '/pros/invitation'
              type: 'POST'
              dataType: 'json'
              data: JSON.stringify(email: str)
              success: ->
                App.request('messenger:explain', 'user.invitation.sent')
              error: (xhr, error, errorType) ->
                try
                  messages = []
                  _.each xhr.responseJSON.error, (val, key) ->
                    message.push("#{key}: #{val.join(', ')}")
                  message = messages.join('; ')
                catch error
                  message = errorType
                App.request('messenger:show', type: 'error', message: message)
