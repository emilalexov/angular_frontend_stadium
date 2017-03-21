define [
  './template'
], (
  template
) ->

  class ActivityItemView extends Marionette.ItemView

    template: template

    tagName: 'li'

    className: 'row'

    templateHelpers: ->
      timeAgo: do =>
        date = @model.get('created_at')
        moment.h.ago(date)

      message: do =>
        action = @model.get('key').split('.')[1]
        who = @model.get('owner_full_name')
        what = "#{@model.get('trackable_type')}##{@model.get('trackable_id')}"
        "#{who} #{action} #{what}"
