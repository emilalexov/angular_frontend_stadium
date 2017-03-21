module.exports = class GroupView extends Marionette.LayoutView

  template: require('templates/trainer/groups/group')

  modelEvents:
    sync: 'render'

  events:
    'change .gc-edit-profile-modal-upload-input': 'showThumbnail'
    'submit @ui.groupForm': 'submitGroupForm'

  ui:
    groupForm: '.group-edit-form'
    groupFormModal: '#gc-edit-group-modal'

  showThumbnail: (ev) ->
    input = ev.target
    if input.files && input.files[0]
      reader = new FileReader()
      reader.onload = (e) ->
        $(ev.target).parents('form')
          .find('.gc-edit-profile-modal-avatar').attr('src', e.target.result)
      reader.readAsDataURL(input.files[0])

  submitGroupForm: (ev) ->
    #TODO validation
    @model.set @ui.groupForm.serializeObject()
    if @model.hasChanged()
      @model.save()
    avatar = $(ev.target).find('input[type=file]')
    if avatar[0].files[0]
      data = new FormData()
      data.append('avatar', avatar[0].files[0])
      $.ajax
        url: "#{@model.url}/avatar"
        type: 'PUT'
        data: data
        cache: false
        dataType: 'json'
        processData: false
        contentType: false
        success: (data) =>
          @model.set 'avatar_url', data.avatar_url
          @render()

    @ui.groupFormModal.modal('hide')
