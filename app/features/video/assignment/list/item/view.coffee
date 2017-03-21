define [
  './template'
], (
  template
)->
  class AssignVideoItemView extends Marionette.ItemView

    template: template

    className: 'col-xs-4 gc-video-thumb'

    ui:
      assignVideo: '.gc-assign-video'
      remove: '.gc-icon-trash'

    events:
      'click @ui.remove': 'removeModel'

    triggers:
      'click @ui.assignVideo': 'assign'

    behaviors:
      video_features: true

      stickit:
        bindings:
          '.gc-video-title':
            observe: 'nameFormatted'
            updateModel: false
          '.gc-video-icon':
            observe: 'filter'
            update: ($el, val, model, options) ->
              $el.addClass "gc-video-#{model.get('filter')}-icon"
          '.gc-video-preview':
            observe: 'preview_picture_url'
            update: ($el, val, model, options) ->
              $el.css 'background-image', "url(#{val})"
          '.gc-video-uploaded-at':
            observe: 'uploaded_at'
            onGet: (date) ->
              moment(date).format 'Do of MMM'
          '.gc-video-duration':
            observe: 'durationFormatted'
            updateModel: false

    templateHelpers: =>
      isAssigned: @options.isAssigned

    removeModel: ->
      @model.urlRoot = '/videos'
      App.request 'modal:confirm',
        title: 'Delete video'
        content: """Are you sure you want to delete video
                    (#{@model.get('nameFormatted')})?"""
        confirmBtn: 'Yes'
        cancelButton: 'No'
        confirmCallBack: =>
          @model.destroy(wait: true)
            .then =>
              App.request 'messenger:explain', 'item.deleted',
                type: @model.type
