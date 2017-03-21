define [
  'models/exercise'
  'models/workout_template'
  'models/program_template'
  './template'
], (
  Exercise
  WorkoutTemplate
  ProgramTemplate
  template
) ->
  class AddEntityModalView extends Marionette.ItemView

    template: template

    className: 'modal-dialog modal-md'

    ui:
      form: 'form'
      nameInput: '.form-control'

    events:
      'submit @ui.form': 'submitForm'

    behaviors:

      form_validation: true

      stickit:
        bindings:
          '[data-bind="name"]': 'name'

    templateHelpers: ->
      singularName: _.chain(@type).humanize().singularize().value()

    initialize: (data) =>
      @type = data.type
      @folder = data.folder
      Klass = @_getModelClass(data.type)
      @model = new Klass(folder_id: @folder.get('id'))
      @listenTo @model, 'error', @_onSyncFail

    onRender: =>
      setTimeout ( =>
        @ui.nameInput.focus()
      ), 400

    submitForm: (ev) =>
      @model.save().then =>
        user = App.request('current_user')
        collection = user[@type]
        collection.add(@model)
        @folder.items.add(@model)
        @$el.parent().modal('hide')
        @_showSuccessMessage()
        event = "#{_.underscored(@model.type)}_created"
        App.vent.trigger('mixpanel:track', event, @model)

    _showSuccessMessage: ->
      App.request('messenger:explain', 'item.added')

    _onSyncFail: (model, data) ->
      for name, error_msg of data.error
        $input = @$el.find("input[name=#{name}]")
        $inputGroup = $input.closest('.form-group')
        @trigger 'switchError', error_msg[0], $inputGroup

    _getModelClass: (type) ->
      {
        exercises: Exercise
        workout_templates: WorkoutTemplate
        program_templates: ProgramTemplate
      }[type]
