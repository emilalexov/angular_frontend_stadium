define [
  './template'
], (
  template
) ->

  class TrainerInfoView extends Marionette.ItemView

    className: 'trainer-info-block'

    template: template

    behaviors: ->
      stickit:
        bindings:
          '.trainer-link':
            observe: 'full_name'
            attributes: [
                name: 'href'
                observe: 'id'
                onGet: (id) -> "/#users/#{id}"
            ]
          '.trainer-avatar':
            attributes: [
                name: 'src'
                observe: 'user_profile.avatar.thumb.url'
            ]
