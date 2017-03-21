define [
  './template'
  'autosize'
], (
  template
  autosize
) ->

  class View extends Marionette.ItemView

    template: template

    className: 'gc-editable-textarea form-group'

    behaviors:

      textarea_autosize: true

      stickit:
        bindings: ->
          '.content':
            observe: 'description'
            updateModel: false
          'textarea':
            observe: 'description'
            attributes: [
                name: 'placeholder'
                observe: 'description'
                onGet: (value) ->
                  'Start typing a description here...'
              ,
                name: 'readonly'
                observe: ['author_id', 'person_id']
                onGet: (values) ->
                  !can('update', @model)
            ]
            classes:
              'empty':
                observe: 'description'
                onGet: (value) ->
                  "#{value}".length is 0

    ui:
      editor: 'textarea'

    events:
      'blur @ui.editor': '_save'

    onBeforeRender: ->
      @model = @options.model()
      @listenToOnce @model, 'sync', ->
        @initialValue = @model.get('description')

    _save: ->
      return if @initialValue is @model.get('description')
      @model.save()
        .then =>
          @initialValue = @model.get('description')
        .fail =>
          @model.set(description: @initialValue)
