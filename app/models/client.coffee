define [
  './user'
], (
  User
) ->

  class Client extends User

    type: 'Client'

    urlRoot: '/clients'

    validation: ->
      obj =
        name:
          required: true
          pattern: /\w+\s+\w+$/
          msg: 'Please enter a first name and a last name'
        email:
          required: false
          pattern: 'email'
          msg: 'Please enter a valid email'

      if @get('invite') or !!@get('email')
        obj.email =
          required: true
      obj

    computed:
      name:
        depends: [
          'first_name'
          'last_name'
        ]
        get: (attrs) ->
          _.compact([
            attrs['first_name']
            attrs['last_name']
          ]).join(' ')
        set: (value, attrs) ->
          [
            attrs.first_name
            attrs.last_name
          ] = _.compact(value.split(' '))
        toJSON: false
