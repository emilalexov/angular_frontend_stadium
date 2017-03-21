define [
  'models/video'
  'backbone.paginator'
], (
  Video
  PageableCollection
) ->

  class Videos extends Backbone.PageableCollection

    type: 'Videos'

    url: ->
      '/videos'

    model: Video

    getPreviousPage: ->
      return false if @state.currentPage <= 1
      super
