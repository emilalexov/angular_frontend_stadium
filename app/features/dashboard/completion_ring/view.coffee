define [
  './model'
  './template'
], (
  Model
  template
) ->

  class CompletionRingView extends Marionette.ItemView

    template: template

    behaviors: ->
      stickit:
        bindings:
          '.counter': 'name'
          '.counter-text': 'description'
          '.progress':
            attributes: [
                name: 'style'
                observe: ['progress', 'progress_max']
                onGet: (values) ->
                  ['stroke-dasharray:'].concat(values).join(' ')
            ]

    initialize: ->
      @model = new Model _.extend {},
        customName: @options.customName
        description: @options.description
        completed: @options.dataModel.get(@options.listen[0])
        total: @options.dataModel.get(@options.listen[1])

      events = "change:#{@options.listen[0]} change:#{@options.listen[1]}"
      @listenTo @options.dataModel, events, ->
        @model.set
          completed: @options.dataModel.get(@options.listen[0])
          total: @options.dataModel.get(@options.listen[1])
