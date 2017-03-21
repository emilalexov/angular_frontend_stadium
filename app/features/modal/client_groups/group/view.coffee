define [
  './template'
], (
  template
) ->

  class GroupModalView extends Marionette.ItemView

    template: template

    behaviors:

      form_validation: true,
      stickit:
        bindings:
          '[name="name"]': 'name'

    className: 'modal-dialog'

    modelEvents:
      'sync': 'onSync'
      'model:avatar_update:success': 'onAvatarUpate'

    ui:
      groupForm: 'form'
      modalUploadInput: '.gc-edit-profile-modal-upload-input'

    events:
      'submit @ui.groupForm': 'submitGroupForm'
      'change @ui.modalUploadInput': 'showThumbnail'

    initialize: ->
      Backbone.Validation.bind @

    showThumbnail: (ev) ->
      input = ev.target
      if input.files?[0]
        reader = new FileReader()
        reader.onload = (e) ->
          $(input).parents('form')
            .find('.gc-edit-profile-modal-avatar')
            .attr('src', e.target.result)
        reader.readAsDataURL(input.files[0])

    submitGroupForm: (ev) =>
      @avatar = $(ev.target).find('input[type=file]')

      if @model.isValid true
        @model.save()

    onSync: ->
      @trigger 'addToGroupsCollection', @model
      if @avatar?[0]?.files?[0]
        data = new FormData()
        data.append('avatar', @avatar[0].files[0])
        @model.updateAvatar data
      @trigger 'modal:closed'

    onAvatarUpate: (data) ->
      model.set 'avatar_url', data.avatar_url
      @trigger 'avatarChange'
