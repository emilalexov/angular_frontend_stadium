define [
  'behaviors/base/regioned'
  './view'
], (
  BaseRegionedBehavior
  View
) ->

  class Behavior extends BaseRegionedBehavior

    regionName: 'video_assigned'

    behaviorViewClass: View

    behaviorViewOptions: ->
      controls: @options.controls
      entity: @model

    defaults:
      controls: true

    behaviors:

      stickit:
        bindings:
          'iframe':
            observe: 'video_url'
            visible: true
            attributes: [
                name: 'src'
                observe: 'video_url'
            ]

    onBeforeRender: ->
      @model = @view.model

    ui:
      buttonDelete: '[role="delete-video"]'

    events:
      'click @ui.buttonDelete': '_deleteVideo'

    _deleteVideo: ->
      App.request 'modal:confirm',
        title: 'Delete Video?'
        content: 'Are you sure you want to delete this video?'
        confirmBtn: 'Delete'
        confirmCallBack: =>
          attrs =
            video_url: null
            video_id: null
          if @options.instantSave is false
            @model.set(attrs)
          else
            @model.save(attrs, wait: true)
          @behaviorView.trigger 'video:deleted'
