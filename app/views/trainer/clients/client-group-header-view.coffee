SendMessageModalView = require 'views/trainer/clients/send-message-modal-view'
ClientFormModalView = require 'views/trainer/clients/client-form-modal-view'
GroupFormModalView = require 'views/trainer/clients/group-form-modal-view'

module.exports = class ClientGroupHeaderView extends Marionette.LayoutView

  template: require('templates/trainer/clients/client-group-header')

  autoRender: false

  modelEvents:
    'sync': 'render'
    'model:invite:success': 'onInvite'
    'model:invite:fail': 'onInviteFail'

  events:
    'submit @ui.inviteForm': 'submitClientForm'
    'click .show-client-form': 'showClientEditModal'
    'click .show-message-form': 'showSendMessageModal'
    'show.bs.modal @ui.inviteModal': 'fillClientEmail'

  regions:
    clientForm: '#gc-edit-client-modal'
    sendMessageForm: '#gc-send-message-modal'

  ui:
    inviteModal: '#gc-invite-client-modal'
    inviteForm: '.invite-client-form'
    inviteEmail: '.invite-client-form input[name=email]'
    clientFormModal: '#gc-edit-client-modal'
    sendMessageModal: '#gc-send-message-modal'

  initialize: (data) ->
    @viewType = data.viewType
    @profile = App.request 'current_user'
    if @model.get('id') is @profile.get('id')
      @myProfile = true

  templateHelpers: =>
    if @viewType is 'clients' then view_type = 1 else view_type = 0
    {view_type: view_type, myProfile: @myProfile}

  fillClientEmail: ->
    @ui.inviteEmail.val @model.get('email')

  submitClientForm: (ev) ->
    #TODO validation
    formData = @ui.inviteForm.serializeObject()
    if @myProfile
      url = '/api/mobile/me/invite'
    else
      url = "/api/mobile/clients/#{@model.get('id')}/invite"

    @model.invite(formData, url)

  onInvite: ->
    @ui.inviteModal.modal('hide')
    App.request('messenger:explain', 'user.invitation.sent')

  onInviteFail: (error) ->
    if error?
      $input = @ui.inviteForm.find('input[name=email]')
      $inputGroup = $input.closest('.form-group')
      $inputGroup.removeClass('gc-valid').addClass('gc-invalid')
      $inputGroup.find('.gc-error-message').text(error)

  showClientEditModal: (ev) ->
    if @viewType is 'clients'
      clientFormModal = new ClientFormModalView model: @model
    else
      clientFormModal = new GroupFormModalView model: @model

    @listenTo clientFormModal, 'modal:close', =>
      @ui.clientFormModal.modal('hide')
    @listenTo clientFormModal, 'avatarChange', =>
      @render()

    @clientForm.show clientFormModal
    @ui.clientFormModal.modal('show')

  showSendMessageModal: (ev) ->
    selectedItems = [@model.id]
    sendMessageModal = new SendMessageModalView selectedItems: selectedItems
    @sendMessageForm.show sendMessageModal
    @ui.sendMessageModal.modal('show')
    @listenTo sendMessageModal, 'modal:close', =>
      @ui.sendMessageModal.modal('hide')
