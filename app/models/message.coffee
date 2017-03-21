define ->

  class Message extends Backbone.Model

    validation:

      body:
        required: true
        msg: 'Type message'

      clients:
        required: true
        msg: 'Choose client'
