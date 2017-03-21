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
      '/videos/search'

    model: Video

    queryParams:
      q: null
      scope: 'mine'
      order: null

    getPreviousPage: ->
      return false if @state.currentPage <= 1
      super
