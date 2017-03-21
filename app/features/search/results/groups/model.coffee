define [
  'models/concerns/avatar_background_color'
], (
  AvatarBackgroundColor
) ->

  class SearchResultItem extends Backbone.NestedModel

    type: 'SearchResultItem'

    initialize: ->
      super
      @_initBgColor()
      @trigger('change:id')


  _.extend(SearchResultItem::, AvatarBackgroundColor)

  SearchResultItem
