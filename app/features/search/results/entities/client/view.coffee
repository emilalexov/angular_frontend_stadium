define [
  './template'
  '../avatar/view'
], (
  template
  AvatarView
) ->

  class ItemView extends Marionette.LayoutView

    template: template

    tagName: 'li'

    className: 'row'

    ui:
      addToLibraryButton: '.gc-add-to-library-button'

    events:
      'click @ui.addToLibraryButton': '_showAddToLibrary'

    behaviors:

      stickit:
        bindings:
          '.gc-clients-list-client-link:first':
            observe: [
              'name'
              'user_profile.first_name'
              'user_profile.last_name'
            ]
            onGet: ([name, first_name, last_name]) ->
              if first_name or last_name
                _.compact([
                  first_name
                  last_name
                ]).join(' ')
              else if name
                name
            attributes: [
              observe: 'id'
              name: 'href'
              onGet: (value) ->
                [
                  '#'
                  _.chain(@model.collection.klass)
                    .underscored()
                    .pluralize()
                    .value()
                  @model.get('id')
                ].join('/')
            ]
          '.gc-avatar-wrapper .gc-clients-list-client-link':
            observe: 'author_full_name'
            attributes: [
              observe: 'author_id'
              name: 'href'
              onGet: (val) ->
                "#/users/#{val}"
            ]
          'a':
            attributes: [
                observe: 'id'
                name: 'href'
                onGet: (val) ->
                  [
                    '#'
                    _.chain(@model.collection.klass)
                      .underscored()
                      .pluralize()
                      .value()
                    @model.get('id')
                  ].join('/')
            ]
          '.gc-clients-list-avatar-wrapper':
            attributes: [
                observe: 'avatar_background_color'
                name: 'style'
                onGet: (val) ->
                  if val
                    "background-color: #{val}"
                  else
                    ''
            ]
            classes:
              'gc-clients-list-avatar-group': 'clients_count'
          'img.gc-avatar':
            observe: 'id'
            visible: ->
              @options.entity_context is 'Users'
            attributes: [
                observe: 'user_profile'
                name: 'src'
                onGet: (val) ->
                  val?.avatar?.thumb?.url
              ,
                observe: 'user_profile'
                name: 'class'
                onGet: (val) ->
                  if val?.avatar?.thumb?.url
                    'gc-clients-list-avatar-exist'
                  else
                    ''
            ]

    _showAddToLibrary: ->
      App.request 'base:addToLibraryModal',
        model: @model
        type: @options.entity_context
