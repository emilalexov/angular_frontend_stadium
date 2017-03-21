define [
  './item/view'
  './collection'
], (
  AccountTypeItemView
  UserAccountTypesCollection
) ->

  class AccountTypeListView extends Marionette.CollectionView

    tagName: 'ul'

    childView: AccountTypeItemView

    initialize: ->
      @collection = new UserAccountTypesCollection
      @collection.fetch()

    saveAccountType: ->
      settings = App.request('current_user').user_settings
      accountType = settings.get('user_account_type_id')
      if accountType
        request = settings.save({}, wait: true)
        request.then ->
          App.request('messenger:explain', 'user.account_type.changed')
        request
      else
        App.request('messenger:explain', 'user.account_type.not_selected')
        false
