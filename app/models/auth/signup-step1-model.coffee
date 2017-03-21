define ->

  class SignUpStep1Model extends Backbone.Model

    urlRoot: '/users.json'

    toJSON: ->
      user: super

    validation:

      account_type:
        required: false
        pattern: 'digits'

      email:
        required: true
        pattern: 'email'

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
