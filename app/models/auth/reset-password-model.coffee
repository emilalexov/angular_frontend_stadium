define ->

  class ResetPasswordModel extends Backbone.Model

    url: '/users/password.json'

    toJSON: ->
      user: _.omit(super, 'id')

    validation:

      password:
        required: true
        minLength: 6
        msg: 'Password must be 6 characters'

      password_confirmation: [
        equalTo: 'password'
        msg: 'The passwords do not match'
      ,
        required: true
        minLength: 6
        msg: 'Password must be 6 characters'
      ]
