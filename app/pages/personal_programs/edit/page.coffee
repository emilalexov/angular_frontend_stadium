define [
  'pages/base/page'
  './template'
  'models/personal_program'
  'pages/program_templates/overview/overview/view'
], (
  BasePage
  template
  PersonalProgram
  EditView
) ->

  class Page extends BasePage

    behaviors:

      navigate_back: true

      breadcrumbs:
        model: ->
          @view.model.get('data.model')

      program_action_panel:
        model: -> @view.model.get('data.model')

    template: template

    regions:
      page_content: 'region[data-name="page_content"]'

    initModel: ->
      new PersonalProgram
        id: @options.id

    initViews: ->
      edit: ->
        new EditView
          model: @model.get('data.model')
