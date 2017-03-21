define [
  './template'
  './user/view'
], (
  template
  UserAvatarView
) ->

  class CommentItemView extends Marionette.LayoutView

    className: 'gc-comment'

    template: template

    behaviors: ->

      stickit:
        bindings:
          ':el':
            observe: 'id'
            visible: true
          '.gc-comment-message': 'comment'
          '.gc-comment-date span:last': 'date'

      regioned:
        views: [
            region: "comment_avatar_#{@options.model.id}"
            klass: UserAvatarView
            options: ->
              model: @model.user
        ]
