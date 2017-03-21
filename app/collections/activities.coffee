define ->

  class Activities extends Backbone.Collection

    type: 'Activities'

    initialize: ->
      super
      @page = 0
      @perPage = 10
      @prevLength = 0
      @noMore = false

    loadMore: (remove) ->
      remove ?= false
      @page += 1
      @fetch
        remove: remove
        data:
          page: @page
          per_page: @perPage
        success: =>
          if @length >= @perPage
            @noMore = @prevLength == @length
          else
            @noMore = true
          @prevLength = @length
