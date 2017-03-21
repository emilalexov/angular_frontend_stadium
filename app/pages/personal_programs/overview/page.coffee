define [
  'pages/base/page'
  './template'
  'models/personal_program'
  './overview/view'
], (
  BasePage
  template
  PersonalProgram
  OverviewView
) ->

  class Page extends BasePage

    behaviors:

      navigate_back: true

      breadcrumbs:
        model: -> @view.model.get('data.model')

      program_action_panel:
        readonly: true
        model: -> @view.model.get('data.model')

    template: template

    regions:
      page_content: 'region[data-name="page_content"]'

    init: ->
      @_redirectToEditIfEmpty()

    initModel: ->
      new PersonalProgram
        id: @options.id

    initViews: ->
      overview: ->
        new OverviewView
          model: @model.get('data.model')

    _redirectToEditIfEmpty: ->
      model = @model.get('data.model')
      @listenToOnce model, 'sync', ->
        if can('update', model) and model.workouts.isEmpty()
          App.request('messenger:explain', 'personal_program.empty')
          path = ['personal_programs', model.id, 'edit']
          App.vent.trigger('redirect:to', path)
