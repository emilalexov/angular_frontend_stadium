define [
  './item/view'
  './empty/start_search'
  './empty/no_results'
  './empty/in_progress'
  './empty/no_videos_uploaded'
], (
  AssignVideoItemView
  StartSearchView
  NoResultsView
  InProgressView
  NoVideosUploadedView
) ->

  class AssignVideosView extends Marionette.CollectionView

    className: 'gc-assign-videos'

    childView: AssignVideoItemView

    getEmptyView: ->
      switch @viewState.get('state')
        when 'search_not_started' then StartSearchView
        when 'no_results' then NoResultsView
        when 'in_progress' then InProgressView
        when 'no_videos_uploaded' then NoVideosUploadedView

    childEvents:
      assign: 'sendEvent'
      playVideo: 'replaceIframe'

    initialize: =>
      @viewState = new Backbone.Model(state: 'library')
      @listenTo(@viewState, 'change:state', @onStateChange)

    childViewOptions: (model, index) =>
      templateEntity: @model
      isAssigned: model.get('embed_url')?.length &&
        @model.get('video_url') is model.get('embed_url')

    onStateChange: ->
      @render() if @collection.length is 0

    sendEvent: (childView) ->
      @trigger('video:assigned', childView.model)

    replaceIframe: (childView) ->
      @activeVideo?.trigger('destroyIframe')
      @activeVideo = childView
