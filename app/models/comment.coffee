define [
  './concerns/nested_models'
  './user'
], (
  NestedModelsConcern
  User
) ->

  class Comment extends Backbone.Model

    type: 'Comment'

    urlRoot: '/comments'

    validation:
      comment:
        required: true

    defaults: ->
      title: ''
      commentable_id: @collection.commentable_id
      commentable_type: @collection.commentable_type
      role: 'comments'

    computed: ->
      date:
        depends: ['created_at']
        get: (attrs) ->
          moment(attrs['created_at']).format('YY/MM/DD HH:mm')
        toJSON: false

    constructor: ->
      @_nestedModelsInit
        user: User
      super

    initialize: ->
      @computedFields = new Backbone.ComputedFields(@)

    parse: (data) ->
      @_nestedModelsParseAll(data)
      data

  _.extend(Comment::, NestedModelsConcern)

  Comment
