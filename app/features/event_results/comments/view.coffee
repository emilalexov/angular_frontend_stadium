define [
  './template'
  './list/view'
  './new_comment_form/view'
], (
  template
  CommentCollectionView
  NewCommentFormView
) ->

  class CommentsLayoutView extends Marionette.LayoutView

    className: 'gc-comment-box clearfix'

    template: template

    behaviors: ->

      regioned:
        views: [
            region: 'comments_list'
            klass: CommentCollectionView
            options: ->
              collection: @options.collection
          ,
            region: 'new_comment_form'
            klass: NewCommentFormView
            options: ->
              collection: @options.collection
        ]
