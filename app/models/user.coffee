define [
  './concerns/nested_models'
  'models/user_profile'
  'models/user_settings'
  'backbone-nested'
], (
  NestedModelsConcern
  UserProfile
  UserSettings
) ->

  class User extends Backbone.NestedModel

    type: 'User'

    urlRoot: '/users/'

    defaults:
      user_profile: {}

    computed: ->
      name:
        depends: [
          'full_name',
        ]
        get: (attrs) ->
          attrs['full_name']
        toJSON: false
      full_name:
        depends: [
          'user_profile.full_name',
        ]
        get: (attrs) ->
          attrs['user_profile.full_name']
        toJSON: false

    constructor: ->
      @_nestedModelsInit
        user_profile: UserProfile
        user_settings: UserSettings
      super

    initialize: ->
      @computedFields = new Backbone.ComputedFields(@)
      @listenTo @user_profile, 'reset change', =>
        @set(user_profile: @user_profile.attributes)
      @listenTo @user_profile, 'change:avatar', (model, value, options) =>
        url = value?.thumb?.url
        @trigger('change:user_profile.avatar.thumb.url', @, url, options)
      @_updateUserProfileAttrs()

    parse: (data) ->
      @_nestedModelsParseAll(data)
      data

    fullName: ->
      _.compact([
        @get('user_profile.first_name')
        @get('user_profile.last_name')
      ]).join(' ')

    invite: (email) ->
      options =
        url: "/users/#{@id}/invite"
        type: 'POST'
        processData: false
        contentType: 'application/json'
      options.data = JSON.stringify(email: email) if email

      request = (@sync || Backbone.sync).call(@, null, @, options)
      request
        .then (response) =>
          @trigger 'invite:success', response
        .fail (xhr, textStatus, errorThrown) =>
          @trigger 'invite:fail', 'Something went wrong'
      request

    getRootFolderFor: (type) ->
      name = _.titleize(type)
      unless _.include([
        'Exercises'
        'Workout Templates'
        'Program Templates'
      ], name)
        throw Error('No such folder')
      rootFolder = @library.first()
      rootFolder.items.findWhere(name: name)

    _updateUserProfileAttrs: ->
      @user_profile.set
        email: @get('email')
        live: @get('live')

  _.extend(User::, NestedModelsConcern)

  User
