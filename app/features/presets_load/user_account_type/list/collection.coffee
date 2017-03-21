define [
  './model'
], (
  UserAccountTypeModel
) ->

  class UserAccountTypesCollection extends Backbone.Collection

    type: 'UserAccountTypes'

    model: UserAccountTypeModel

    url: '/user_account_types'
