define ->

  class Model extends Backbone.Model

    urlRoot: '/pros'

    defaults:
      name: ''
      first_name: ''
      last_name: ''
      email: ''

    computed: ->
      name:
        depends: [
          'first_name'
          'last_name'
        ]
        get: (attrs) ->
          _.compact([attrs.first_name, attrs.last_name]).join(' ')
        set: (value, attrs) ->
          arr = value.split(' ')
          attrs.first_name = arr.shift()
          attrs.last_name = arr.join(' ')
        toJSON: false

    initialize: ->
      @computedFields = new Backbone.ComputedFields(@)

    invite: (email) ->
      @_xhrCompose('invite', email)

    request: ->
      @_xhrCompose('request')

    _xhrCompose: (url, email) ->
      options =
        url: "/pros/#{url}"
        type: 'POST'
        processData: false
        contentType: 'application/json'
      options.data = JSON.stringify(email: email) if email

      (@sync || Backbone.sync).call(@, null, @, options)
