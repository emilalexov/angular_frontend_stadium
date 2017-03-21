define [
  './model'
], (
  DayModel
) ->

  class DaysCollection extends Backbone.Collection

    model: DayModel
