module.exports = class GroupFormModalView extends Marionette.ItemView

  template: require('templates/trainer/clients/group-form-modal')

  behaviors:

    form_validation: true

  className: 'modal-dialog'

  modelEvents:
    'sync': 'onSync'
    'model:avatar_update:success': 'onAvatarUpate'

  events:
    'submit @ui.groupForm': 'submitGroupForm'
    'change .gc-edit-profile-modal-upload-input': 'showThumbnail'
    'blur form input': 'validateInput'

  ui:
    groupForm: 'form'

  initialize: =>
    Backbone.Validation.bind @

  validateInput: (ev) ->
    $input = $(ev.target)
    input_name = $(ev.target).attr 'name'
    input_value = $(ev.target).val()
    if input_value
      $inputGroup = $input.closest('.form-group')
      error_msg = @model.preValidate input_name, input_value
      @trigger 'switchError', error_msg, $inputGroup

  showThumbnail: (ev) ->
    input = ev.target
    if input.files?[0]
      reader = new FileReader()
      reader.onload = (e) ->
        $(ev.target).parents('form')
          .find('.gc-edit-profile-modal-avatar')
          .attr('src', e.target.result)
      reader.readAsDataURL(input.files[0])

  submitGroupForm: (ev) =>
    @avatar = $(ev.target).find('input[type=file]')
    formData = @ui.groupForm.serializeObject()
    for key, value of formData
      if not value
        delete formData[key]
    @model.set formData
    if @model.isValid true
      App.vent.trigger('spinner:start')
      @model.save()

  onSync: ->
    App.vent.trigger ''
    @trigger 'closeModal'
    @trigger 'addToGroupsCollection', @model
    if @avatar?[0]?.files?[0]
      data = new FormData()
      data.append('avatar', @avatar[0].files[0])
      @model.updateAvatar data

  onAvatarUpate: (data) ->
    model.set 'avatar_url', data.avatar_url
    @trigger 'avatarChange'
