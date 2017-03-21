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

      regioned:
        views: [
            region: 'avatar'
            klass: AvatarView
        ]

      stickit:
        bindings:
          '[data-name="is_in_my_library"]':
            attributes: [
                observe: 'is_in_my_library'
                name: 'class'
                onGet: (val) ->
                  type = @options.entity_context
                  if type != 'exercises'
                    type = "#{_.singularize(type)}_templates"
                  if val
                    'gc-check-icon'
                  else
                    "gc-exercises-item-icon gc-exercises-item-icon-#{type}"
            ]
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
          '.gc-exercises-item-play-icon':
            attributes: [
              observe: 'video_url'
              name: 'style'
              onGet: (val) ->
                if val
                  'display: inline-block;'
                else
                  'display: none;'
            ]
          '.actions':
            classes:
              'gc-not-in-library':
                observe: 'is_in_my_library'
                onGet: (val) ->
                  not val

    _showAddToLibrary: ->
      App.request 'base:addToLibraryModal',
        model: @model
        type: @options.entity_context
