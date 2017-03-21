define [
  './concerns/avatar_background_color'
], (
  AvatarBackgroundColor
) ->

  class UserProfile extends Backbone.Model

    type: 'UserProfile'

    urlRoot: '/user_profiles'

    defaults:
      avatar_background_color: ''
      avatar:
        url: ''
        large: url: ''
        thumb: url: ''

    computed: ->
      full_name:
        depends: [
          'first_name',
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

      height_feet:
        depends: ['height']
        get: (attrs) ->
          Math.floor(attrs.height / 12)
        set: (value, attrs) ->
          value = parseInt(value, 10) || 0
          attrs.height = value * 12 + @get('height_inches')
        toJSON: false

      height_inches:
        depends: ['height']
        get: (attrs) ->
          attrs.height % 12
        set: (value, attrs) ->
          value = parseInt(value, 10) || 0
          attrs.height = @get('height_feet') * 12 + value
        toJSON: false

    validation:

      first_name:
        required: true

      last_name:
        required: true

      zip:
        required: false
        pattern: 'digits'

      works_at:
        required: false

    initialize: ->
      super
      @computedFields = new Backbone.ComputedFields(@)
      @_initBgColor()

  _.extend(UserProfile::, AvatarBackgroundColor)

  UserProfile
