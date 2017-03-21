define [
  'models/user'
], (
  User
) ->

  class CurrentUser extends User

    url: '/users/me'

    urlRoot: '/users/me'
