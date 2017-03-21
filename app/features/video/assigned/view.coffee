define [
  './template'
  'models/video'
], (
  template
  Video
) ->

  class View extends Marionette.LayoutView

    template: template

    className: 'gc-video-assigned'

    behaviors: ->

      stickit:
        bindings:
          '.gc-video-assigned-wrapper':
            observe: 'embed_url'
            visible: (value) -> value
          '.gc-video-assigned-placeholder':
            observe: 'embed_url'
            visible: (value) -> !value
          '.gc-video-link':
            attributes: [
                name: 'href'
                observe: 'embed_url'
            ]
          '.gc-video-link span.name': 'name'
          '.gc-video-link span.type':
            observe: 'embed_url'
            onGet: (value) ->
              type = @_getVideoType(value)
              _.capitalize(type)
          '.gc-video-icon':
            classes:
              'gc-video-vimeo-icon':
                observe: 'embed_url'
                onGet: (value) ->
                  @_getVideoType(value) is 'vimeo'
              'gc-video-youtube-icon':
                observe: 'embed_url'
                onGet: (value) ->
                  @_getVideoType(value) is 'youtube'
          '.gc-video-preview':
            attributes: [
                name: 'style'
                observe: 'preview_picture_url'
                onGet: (val) ->
                  if val
                    "background-image: url(#{val})"
            ]
          '.gc-video-duration':
            observe: 'durationFormatted'
            visible: true
            updateView: true
          '.gc-video-uploaded-at':
            observe: 'uploaded_at'
            onGet: (date) ->
              moment(date).format 'Do of MMM'
          '.gc-video-controls':
            visible: -> @options.controls
          '.gc-add-video':
            visible: -> @options.controls
          '.gc-video-play':
            observe: 'embed_url'
            visible: true

    ui:
      buttonAssign: '.gc-add-video'
      replace: '.gc-video-replace'
      play: '.gc-video-play'
      iframe: 'iframe'
      duration: '.gc-video-duration'

    events:
      'click @ui.play': '_renderIframe'

    triggers:
      'click @ui.buttonAssign': 'video:assign'
      'click @ui.replace': 'video:assign'

    initialize: ->
      @model = new Video
        id: @options.entity.get('video_id')
        embed_url: @options.entity.get('video_url')

      @listenTo(@options.entity, 'change:video_id', @_onVideoIdChange)
      @listenTo(@options.entity, 'change:video_url', @_onVideoUrlChange)

    _renderIframe: (ev) ->
      App.vent.trigger('mixpanel:track', 'video_watched', @model)
      @ui.iframe.show()
      @ui.iframe.attr('src', "#{@model.get('embed_url')}?autoplay=1")
      $(ev.currentTarget).hide()
      @ui.duration.hide()

    _onVideoIdChange: (_entity, id) ->
      return unless id
      @model.set('id', id, silent: true)
      @model.fetch()

    _onVideoUrlChange: (_entity, url) ->
      @model.set(embed_url: url)

    _getVideoType: (url) ->
      return unless _.any(url)
      url.indexOf('vimeo') isnt -1 && 'vimeo' || 'youtube'
