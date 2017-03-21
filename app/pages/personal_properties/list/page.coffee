define [
  'pages/base/page'
  './template'
  'features/properties/list/view'
], (
  BasePage
  template
  PropertyListView
) ->

  class Page extends BasePage

    template: template

    regions:
      page_content: 'region[data-name="page_content"]'

    initCollection: ->
      App.request('current_user').personal_properties

    initViews: ->
      list: ->
        new PropertyListView
          collection: @model.get('data.collection')

    onShow: ->
      @trigger('views:show', 'list', 'page_content')
