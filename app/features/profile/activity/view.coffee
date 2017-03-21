define [
  './empty/view'
  './item/view'
  'collections/user_collection'
  './template'
], (
  EmptyView
  ItemView
  UserCollection
  template
) ->
  class ActivityView extends Marionette.CompositeView

    template: template

    emptyView: EmptyView

    childView: ItemView

    childViewContainer: 'ul'

    events:
      'click @ui.loadMore': 'loadMore'

    ui:
      loadMore: '.load-more'

    initialize: (options) ->
      unless @collection
        @collection = new UserCollection [],
          user: options.user,
          type: 'notifications'
        @collection.fetch()

    templateHelpers: ->
      noMore: @collection?.noMore

    loadMore: (ev) ->
      @collection.loadMore()

    refresh: (_ev) ->
      @collection.page = 0
      @collection.prevLength = 0
      @collection.loadMore(true)
