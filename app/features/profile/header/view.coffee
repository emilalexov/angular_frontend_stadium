define [
  'views/trainer/clients/send-message-modal-view'
  './template'
], (
  SendMessageModalView
  template
) ->

  class HeaderView extends Marionette.LayoutView

    template: template

    id: 'client-header-region'

    modelEvents:
      'model:invite:success': 'onInvite'
      'model:invite:fail': 'onInviteFail'

    events:
      'submit @ui.inviteForm': 'submitClientForm'
      'click .show-message-form': 'showSendMessageModal'
      'show.bs.modal @ui.inviteModal': 'fillClientEmail'

    behaviors: ->

      stickit:
        model: => @model.user_profile
        bindings:
          '.gc-usercard-avatar-wrapper':
            attributes: [
                observe: 'avatar'
                name: 'class'
                onGet: (value) ->
                  'gc-usercard-avatar-exist' if _.any(value.large.url)
            ]
          'img.gc-usercard-avatar':
            attributes: [
                observe: 'avatar'
                name: 'src'
                onGet: (value) ->
                  value.large.url
            ]
          'span[data-bind="location"]': 'location'
          'span[data-bind="zip"]': 'zip'
          'span[data-bind="first_name"]': 'first_name'
          'span[data-bind="last_name"]': 'last_name'
          'dd[data-bind="height"]':
            observe: ['height', 'height_feet', 'height_inches']
            onGet: ([height, feet, inches]) ->
              height and "#{feet}' #{inches}\"" or '-'
          'dd[data-bind="weight"]':
            observe: 'weight'
            onGet: '_formatEmptyValue'
          'dd[data-bind="bodyfat"]':
            observe: 'bodyfat'
            onGet: '_formatEmptyValue'
          'dd[data-bind="gender"]':
            observe: 'gender'
            onGet: '_formatEmptyValue'
          'dd[data-bind="birthday"]':
            observe: 'birthday'
            onGet: (value)->
              date = moment(value)
              if date.isValid() then date.fromNow(true) else '-'
          '.show-client-form':
            attributes: [
              observe: 'id'
              name: 'href'
              onGet: ->
                "#users/#{@model.id}/edit"
            ]
          '.invite-client-button, client-title':
            observe: 'id'
            onGet: ->
              "Invite #{@_clientTitle()}"
          '.client-title-label':
            observe: 'id'
            onGet: ->
              "#{@_clientTitle()}'s email"


    regions:
      sendMessageForm: '#gc-send-message-modal'

    ui:
      inviteButton: '.invite-client-button'
      inviteModal: '#gc-invite-client-modal'
      inviteForm: '.invite-client-form'
      inviteEmail: '.invite-client-form input[name=email]'
      clientFormModal: '#gc-edit-client-modal'
      sendMessageModal: '#gc-send-message-modal'

    templateHelpers: ->
      isMyProfile: @_isMyProfile()

    onDestroy: ->
      @ui.clientFormModal.off('hidden.bs.modal')

    _isMyProfile: ->
      @model.get('id') is App.request('current_user_id')

    _clientTitle: ->
      currentUser = App.request('current_user').user_settings
      _.singularize(currentUser.get('clients_title'))

    fillClientEmail: ->
      @ui.inviteEmail.val @model.get('email')

    submitClientForm: (ev) ->
      formData = @ui.inviteForm.serializeObject()
      @model.invite(formData.email)
        .then =>
          @ui.inviteModal.modal('hide')
          App.request('messenger:explain', 'user.invitation.sent')
        .fail (xhr, error, errorType) ->
          try
            error = xhr.responseJSON.error
            message = "email #{error.email.join(', ')}"
          catch error
            message = errorType
          App.request 'messenger:explain', 'message:error',
            message: message

    onInvite: ->
      @ui.inviteModal.modal('hide')
      App.request('messenger:explain', 'user.invitation.sent')

    onInviteFail: (error) ->
      return unless error

      $input = @ui.inviteForm.find('input[name=email]')
      $inputGroup = $input.closest('.form-group')
      $inputGroup.removeClass('gc-valid').addClass('gc-invalid')
      $inputGroup.find('.gc-error-message').text(error)

    showSendMessageModal: (ev) ->
      selectedItems = [@model.id]
      sendMessageModal = new SendMessageModalView selectedItems: selectedItems
      @sendMessageForm.show sendMessageModal
      @ui.sendMessageModal.modal('show')
      @listenTo sendMessageModal, 'modal:close', =>
        @ui.sendMessageModal.modal('hide')

    _formatEmptyValue: (value) ->
      _.any(value) && value || '-'
