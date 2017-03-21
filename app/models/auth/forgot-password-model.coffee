define ->

  class ForgotPasswordModel extends Backbone.Model

    url: '/users/password.json'

    toJSON: ->
      user: super

    validation:

      email:
        required: true
        pattern: 'email'
