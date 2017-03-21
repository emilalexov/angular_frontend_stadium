define [
  'backbone'
], (
  Backbone
) ->

  class Video extends Backbone.Model

    urlRoot: '/videos'

    defaults:
      duration: undefined
      embed_url: undefined
      id: undefined
      name: undefined
      preview_picture_url: undefined
      status: undefined
      uploaded_at: undefined
      vimeo_id: undefined
      vimeo_url: undefined
