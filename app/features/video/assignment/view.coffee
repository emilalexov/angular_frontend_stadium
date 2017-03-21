define [
  './template'
  './list/view'
  './search/view'
  'collections/videos'
], (
  template
  AssignVideosView
  SearchInputView
  VideosCollection
) ->

  class VideosView extends Marionette.LayoutView

    template: template

    regions:
      videos: 'region.gc-videos'
      search: 'region.video-search'

    ui:
      innerNavItems: '.gc-assign-video-filter li'
      innerNavLinks: '.gc-assign-video-filter li a'
      uploadButton: '.gc-upload-video'

    className: 'gc-assign-video-layout'

    events:
      'click @ui.innerNavLinks': 'changeViewEvent'
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
          query: @model.get('name')
      @searchScope = 'mine'
      @view = new AssignVideosView
        collection: @collection
        model: @model
      @listenTo(@view, 'video:assigned', @assignVideo)
      @listenTo(@searchInput, 'searchStart', @searchVideos)
      @searchVideos(@model.get('name'))

    onShow: ->
      @getRegion('videos').show(@view)
      @getRegion('search').show(@searchInput)

    changeViewEvent: (ev) ->
      navItem = $(ev.currentTarget).parent()
      @searchScope = $(ev.currentTarget).data('scope')
      unless $(navItem).hasClass 'active'
        @ui.innerNavItems.removeClass 'active'
        $(navItem).addClass 'active'
        query = _.trim(@searchInput.model.get('query'))
        if query
          @collection.reset()
          @view.viewState.set('state', 'in_progress')
          @searchVideos(query)
        else if !query and @searchScope is 'mine'
          @collection.reset()
          @view.viewState.set('state', 'library')
          @searchVideos(query)
        else
          @view.viewState.set('state', 'search_not_started')
          @collection.reset()
      @collection.trigger('request')

    searchVideos: (query) ->
      @request.abort() if @request?.state() is 'pending'
      # Commenting because serch will always have query for now
      # if !_.trim(query) && @searchScope != 'mine'
      #   @view.viewState.set('state', 'search_not_started')
      #   return

      @collection.queryParams.q = query
      @collection.queryParams.scope = @searchScope
      @request = @collection.fetch
        data:
          q: query
          scope: @searchScope
        reset: true

      @request
        .then (response) =>
          @collection.trigger('request')
          unless response.length
            if @searchScope is 'mine'
              @view.viewState.set('state', 'no_videos_uploaded')
            else
              @view.viewState.set('state', 'no_results')
        .fail ->
          return false if arguments[1] is 'abort'
          App.request('messenger:explain', 'video.search.error')

    openUploadPopup: ->
      view = App.request('base:uploadVideo')
      @listenToOnce(view, 'videoUploaded', @_videoUploaded)

    _videoUploaded: (model) ->
      @assignVideo(model)
      @collection.unshift(model)

    assignVideo: (model) ->
      attrs =
        video_url: model.get('embed_url')
        video_id: @_getVideoId(model)
      if @options.instantSave is false
        @model.set(attrs)
      else
        @model.save(attrs, wait: true)
      return unless @options.type is 'modal'
      App.vent.trigger('fetch:video', attrs.video_id)
      App.vent.trigger('modal:video:close')

    _getVideoId: (model) ->
      if model.get('type') is 'gymcloud'
        model.get('id')
      else
        null
