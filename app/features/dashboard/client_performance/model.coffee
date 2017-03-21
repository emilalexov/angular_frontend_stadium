define [
  'models/concerns/avatar_background_color'
], (
  AvatarBackgroundColor
) ->

  class ClientPerformance extends Backbone.Model

    initialize: ->
      super
      @_initBgColor()


  _.extend(ClientPerformance::, AvatarBackgroundColor)

  ClientPerformance
