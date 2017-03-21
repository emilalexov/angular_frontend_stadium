define [
  './template'
  'models/user'
], (
  template
  User
) ->

  class View extends Marionette.ItemView

    template: template

    className: 'gc-author-widget'

    constructor: ->
      @model = new User
      super

    initialize: ->
      @listenTo(@options.parent, 'sync', @_syncWithParentModel)

    behaviors:

      stickit:
        bindings:
          'a':
            attributes: [
                name: 'href'
                observe: 'id'
                onGet: (value) ->
                  "#users/#{value}"
            ]
          'img':
            attributes: [
                name: 'src'
                observe: 'user_profile.avatar.thumb.url'
            ]
          'a:last':
            observe: [
              'user_profile.first_name'
              'user_profile.last_name'
            ]
            onGet: ([first_name, last_name]) ->
              _.compact([
                first_name
                last_name
              ]).join(' ')

    _syncWithParentModel: ->
      @model.set
        id: @options.parent.get('author_id')
      @model.fetch()
