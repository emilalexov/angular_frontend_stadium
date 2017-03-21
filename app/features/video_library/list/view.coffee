define [
  './item/view'
  'features/video/assignment/list/empty/start_search'
  'features/video/assignment/list/empty/no_results'
  'features/video/assignment/list/empty/no_videos_uploaded'
], (
  VideoItemView
  StartSearchView
  NoResultsView
  EmptyView
) ->

  class ManageVideosView extends Marionette.CollectionView

    className: 'gc-manage-videos'

    childView: VideoItemView

    childViewOptions: ->
      set_template: 'video_library'

    getEmptyView: ->
      switch @viewState.get('state')
        when 'search_not_started' then StartSearchView
        when 'no_results'
          if @collection.queryParams.q then NoResultsView else EmptyView

    childEvents:
      playVideo: 'replaceIframe'

    initialize: =>
      @viewState = new Backbone.Model(state: 'library')
      @listenTo(@viewState, 'change:state', @onStateChange)

    onStateChange: ->
      @render() if @collection.length is 0

    replaceIframe: (childView) ->
      @activeVideo?.trigger('destroyIframe')
      @activeVideo = childView
