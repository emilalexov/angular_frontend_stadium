define [
  './template'
  './list/view'
  'features/video/assignment/search/view'
  './collection'
], (
  template
  VideosListView
  SearchInputView
  VideosCollection
) ->

  class VideosView extends Marionette.LayoutView

    template: template

    regions:
      videos: 'region[data-name="videos"]'
      search: 'region.video-search'

    ui:
      uploadButton: '.gc-upload-video'
      elementsFrom: '.gc-emelents-from'
      elementsTo: '.gc-elements-to'
      elementsTotal: '.gc-elements-total'

    className: 'gc-manage-video-layout'

    events:
      'click @ui.uploadButton': 'openUploadPopup'

    behaviors:
      pagination: true

    constructor: ->
      @collection = new VideosCollection
      super

    initialize: ->
      @request = null
      @searchInput = new SearchInputView
        model: new Backbone.Model
      @view = new VideosListView
        collection: @collection
      @listenTo(@searchInput, 'searchStart', @initSearchWithQuery)
      @listenTo(@, 'order', @initSearchWithOrder)
      @searchVideos('', @options.order)

    initSearchWithQuery: (query) ->
      @searchVideos(query, @collection.queryParams.order)

    initSearchWithOrder: (order) ->
      @searchVideos(@collection.queryParams.q, order)
      Backbone.history.navigate('videos/' + order)

    onShow: ->
      @getRegion('videos').show(@view)
      @getRegion('search').show(@searchInput)

    searchVideos: (query, order) ->
      @request.abort() if @request?.state() is 'pending'

      @collection.queryParams.q = query
      @collection.queryParams.order = order
      @request = @collection.fetch
        data:
          q: query
          order: order
        reset: true

      @request
        .then (response) =>
          @collection.trigger('request')
          @view.viewState.set('state', 'no_results') unless response[1].length
        .fail ->
          return false if arguments[1] is 'abort'
          App.request('messenger:explain', 'video.search.error')

    openUploadPopup: ->
      view = App.request('base:uploadVideo')
      @listenToOnce(view, 'videoUploaded', @_videoUploaded)

    _videoUploaded: (model) ->
      @collection.unshift(model)
