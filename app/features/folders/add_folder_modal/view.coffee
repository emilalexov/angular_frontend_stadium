define [
  'models/folder'
  './template'
], (
  Folder
  template
) ->

  class AddFolderModalView extends Marionette.ItemView

    template: template

    className: 'modal-dialog modal-md'

    behaviors:

      form_validation: true

      stickit:
        bindings:
          '[data-bind="name"]': 'name'

    ui:
      form: 'form'

    events:
      'submit @ui.form': 'submitForm'

    initialize: (data) =>
      @parent = data.parent
      @model = new Folder
        parent_id: @parent.get('id')

    submitForm: (ev) ->
      @model.save().then =>
        user = App.request('current_user')
        folders = user.folders
        folders.add(@model)
        @parent.items.unshift(@model)
        @$el.parent().modal 'hide'
        @_showSuccessMessage()

    _showSuccessMessage: ->
      App.request('messenger:explain', 'folder.added')
