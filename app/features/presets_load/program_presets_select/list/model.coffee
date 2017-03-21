define [
  'models/concerns/nested_models'
  './item/program_list/collection'
], (
  NestedModelsConcern
  Programs
) ->

  class ProgramPresetModel extends Backbone.Model

    type: 'ProgramPreset'

    defaults:
      id: undefined
      name: ''
      is_selected: false
      program_template_ids: []

    constructor: ->
      @_nestedModelsInit
        program_templates: Programs
      super

    initialize: ->
      @listenTo(@program_templates, 'change:is_selected', @_updateProgramIds)
      @listenTo(@, 'change:is_selected', @_changeIsSelected)

    _changeIsSelected: (_model, value, _options) ->
      if value and _.isEmpty(@get('program_template_ids'))
        @program_templates.each((model) -> model.set(is_selected: true))

    _updateProgramIds: ->
      models = @program_templates.filter((model) -> model.get('is_selected'))
      ids = _.pluck(models, 'id')
      @set(is_selected: false) if ids.length is 0
      @set(program_template_ids: ids)

    parse: (data) ->
      @_nestedModelsParseAll(data)
      data

    import: ->
      options =
        url: "#{@url()}/import"
        data: JSON.stringify
          program_template_ids: @get('program_template_ids')

      options = App.request 'ajax:options:create', options

      (@sync || Backbone.sync).call(@, null, @, options)


  _.extend(ProgramPresetModel::, NestedModelsConcern)

  ProgramPresetModel
