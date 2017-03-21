define [
  'pages/base/page'
  './template'
  'features/video_library/view'
], (
  BasePage
  template
  VideosView
) ->

  class Page extends BasePage

    behaviors:

      navigation_content_tabs:
        data: [
            id: 'recent'
            title: 'Recent'
          ,
            id: 'oldest'
            title: 'Oldest'
        ]

    template: template

    regions:
      page_content: 'region[data-name="page_content"]'

    initViews: ->
      list: ->
        @view = new VideosView
          state: @model.get 'state.subpage'
          order: @options.order
      recent: ->
        @view.trigger('order', 'recent')
      oldest: ->
        @view.trigger('order', 'oldest')
