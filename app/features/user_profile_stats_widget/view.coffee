define [
  './template'
  'models/user'
], (
  template
  User
) ->

  class UserProfileStatsWidget extends Marionette.ItemView

    className: 'gc-user-profile-stats-widget'

    template: template

    behaviors: ->

      stickit:
        bindings:
          '.height .value span':
            observe: 'user_profile.height'
            onGet: @_formatedValue
            afterUpdate: @_toggleUnits
          '.weight .value span':
            observe: 'user_profile.weight'
            onGet: @_formatedValue
            afterUpdate: @_toggleUnits
          '.bodyfat .value span':
            observe: 'user_profile.bodyfat'
            onGet: @_formatedValue
          '.age .value span':
            observe: 'user_profile.age'
            onGet: @_formatedValue
          '.gender .value span':
            observe: 'user_profile.gender'
            onGet: @_formatedValue
          '.name': 'name'
          '.avatar img':
            attributes: [
                name: 'src'
                observe: 'user_profile.avatar.thumb.url'
            ]

    initialize: ->
      @listenToOnce(@options.event, 'sync', @_loadPerson)
      @model = new User

    _loadPerson: ->
      @model.set
        id: @options.event.get('person_id')
        user_profile:
          full_name: @options.event.get('person_name')
          avatar: thumb: url: @options.event.get('person_avatar')
      @model.fetch()

    _formatedValue: (value) ->
      value or '-'

    _toggleUnits: ($el, value) ->
      if value is '-'
        $el.siblings().hide()
      else
        $el.siblings().show()
