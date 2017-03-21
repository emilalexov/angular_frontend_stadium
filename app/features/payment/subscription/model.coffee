define [
  'backbone-nested'
], ->

  class Subscription extends Backbone.NestedModel

    url: ->
      user = App.request('current_user')
      "/users/#{user.id}/subscription"
