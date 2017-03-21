define [
  'pages/base/page'
  './template'
  'models/exercise'
  './overview/view'
], (
  BasePage
  template
  Exercise
  OverviewView
) ->

  class Page extends BasePage

    behaviors:

      navigate_back: true

      breadcrumbs:
        model: ->
          @view.model.get('data.model')

    template: template

    regions:
      page_content: 'region[data-name="page_content"]'

    initModel: ->
      user = App.request('current_user')
      exercise = user.exercises?.get(@options.id)
      exercise or new Exercise(id: @options.id)

    initViews: ->
      overview: ->
        new OverviewView
          model: @model.get('data.model')
          user: @options.user
