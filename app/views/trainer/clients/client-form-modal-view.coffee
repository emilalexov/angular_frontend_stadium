module.exports = class ClientFormModalView extends Marionette.ItemView

  template: require('templates/trainer/clients/client-form-modal')

  className: 'modal-dialog gc-client-modal'

  behaviors:

    form_validation: true

    stickit:
      bindings:
        'input[name="email"]': 'email'
        'input[name="name"]': 'name'
        'client-title':
          observe: ['id', 'first_name', 'last_name']
          onGet: ([id, first_name, last_name]) ->
            if id
              "Edit #{first_name} #{last_name} information"
            else
              settings = App.request('current_user').user_settings
              title = _.singularize(settings.get('clients_title'))
              "Add #{title}"

  events:
    'submit @ui.clientForm': 'submitClientForm'
    'click button[data-action="invite"]': '_saveAndInvite'
    'change .gc-edit-profile-modal-upload-input': 'showThumbnail'
    'blur form input': 'validateInput'

  modelEvents:
    'sync': 'onSync'
    'error': 'onSyncError'
    'model:avatar_update:success': 'onAvatarUpdate'

  ui:
    clientForm: 'form'

  initialize: =>
    Backbone.Validation.bind @

  validateInput: (ev) ->
    $input = $(ev.target)
    input_name = $(ev.target).attr 'name'
    input_value = $(ev.target).val()
    $inputGroup = $input.closest('.form-group')
    error_msg = @model.preValidate input_name, input_value
    @trigger 'switchError', error_msg, $inputGroup

  showThumbnail: (ev) ->
    input = ev.target
    if input.files && input.files[0]
      reader = new FileReader()
      reader.onload = (e) ->
        $(ev.target).parents('form')
          .find('.gc-edit-profile-modal-avatar')
          .attr('src', e.target.result)
      reader.readAsDataURL(input.files[0])

  submitClientForm: (ev, invite = false) =>
    formData = @ui.clientForm.serializeObject()
    for key, value of formData
      if key in ['weight, height, bodyfat']
        formData[key] = value.replace(/\,/g, '.')
      if not value
        delete formData[key]
    formData.invite = invite
    @model.set(formData)
    return unless @model.isValid true
    request = @model.save()
    request.fail(@_onRequestFail)
    if invite
      request.then (response) =>
        @_inviteClient(@model.get('email'))

  _saveAndInvite: (ev) ->
    ev.preventDefault()
    ev.stopImmediatePropagation()
    @submitClientForm(ev, true)

  _inviteClient: (email) ->
    @model.invite(email)
      .then ->
        App.request('messenger:explain', 'user.invitation.sent')
        App.vent.trigger('mixpanel:track', 'client_invited', @model)
      .fail(@_onRequestFail)

  _onRequestFail: (xhr, error, errorType) ->
    try
      error = xhr.responseJSON.error
      message = _.humanize(error.join(', '))
    catch error
      message = errorType
    App.request 'messenger:explain', 'message.error',
      message: message

  onSync: (model, response, options) ->
    App.request('messenger:explain', 'client.added')
    App.vent.trigger('mixpanel:track', 'client_added', @model)
    @trigger 'modal:close'
    @trigger 'addToClientsCollection', model
    App.request('current_user').clients.add(@model)
    App.request('current_user').clients.fetch(reset: true)

  onAvatarUpdate: (response) ->
    @model.set 'avatar_url', data.avatar_url
    @trigger 'avatarChange'

  onSyncError: (model, response, options) ->
    #todo implement sync error
