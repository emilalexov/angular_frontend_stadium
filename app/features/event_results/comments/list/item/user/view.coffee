define [
  './template'
], (
  template
) ->

  class UserAvatarView extends Marionette.ItemView

    template: template

    tagName: 'a'

    className: 'gc-comment-avatar'

    behaviors:

      stickit:
        bindings:
          ':el':
            attributes: [
                name: 'href'
                observe: 'id'
                onGet: (value) ->
                  "#users/#{value}"
              ,
                name: 'alt'
                observe: 'full_name'
            ]
          'img':
            attributes: [
                name: 'src'
                observe: 'user_profile.avatar.thumb.url'
              ,
                name: 'alt'
                observe: 'full_name'
            ]
