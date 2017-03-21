define [
  './item/view'
  'collections/user_collection'
  './model'
], (
  ItemView
  UserCollection
  UserAuthentication
) ->

  class UserAuthenticationsView extends Marionette.CollectionView

    childView: ItemView

    initialize: ->
      @collection = new UserCollection [],
        type: 'user_authentications'
        model: UserAuthentication
      @listenTo(@, 'oauthCreated', @addOauth)

    onShow: ->
      @collection.fetch()

    addOauth: ->
      @collection.fetch()
