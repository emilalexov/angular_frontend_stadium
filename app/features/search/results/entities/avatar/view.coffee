define [
  './template'
], (
  template
) ->

  class View extends Marionette.ItemView

    template: template

    tagName: 'a'

    className: 'gc-clients-list-avatar-wrapper'

    behaviors:

      stickit:
        bindings:
          ':el':
            attributes: [
                observe: 'author_id'
                name: 'href'
                onGet: (val) ->
                  "#/users/#{val}"
              ,
                observe: 'avatar_background_color'
                name: 'style'
                onGet: (val) ->
                  if val
                    "background-color: #{val}"
                  else
                    ''
            ]
          'img.gc-avatar':
            attributes: [
                observe: 'avatar_url'
                name: 'src'
              ,
                observe: 'avatar_url'
                name: 'class'
                onGet: (val) ->
                  if val
                    'gc-clients-list-avatar-exist'
                  else
                    ''
            ]
