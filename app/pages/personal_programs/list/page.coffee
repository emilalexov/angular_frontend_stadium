define [
  'pages/base/page'
  './template'
  'features/personal_entities/view'
], (
  BasePage
  template
  ListView
) ->

  class Page extends BasePage

    template: template

    regions:
      page_content: 'region[data-name="page_content"]'

    initCollection: ->
      App.request('current_user').personal_programs

    initViews: ->
      list: ->
        new ListView
          collection: @model.get('data.collection')