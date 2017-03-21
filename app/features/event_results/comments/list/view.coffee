define [
  './item/view.coffee'
], (
  CommentItemView
) ->

  class CommentCollectionView extends Marionette.CollectionView

    childView: CommentItemView
