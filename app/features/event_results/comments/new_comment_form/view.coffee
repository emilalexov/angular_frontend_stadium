define [
  './template'
], (
  template
) ->

  class NewCommentFormView extends Marionette.ItemView

    template: template

    className: 'gc-comment-enter-message'

    behaviors:

      stickit:
        bindings:
          'textarea' : 'comment'

    initialize: ->
      @model = @options.collection.add({})

    events:
      'click button': '_addComment'
      'keydown textarea': '_onPressEnter'

    _addComment: ->
      @options.collection.create @model.toJSON(),
        wait: true
        success: =>
          @model.clear()
          App.vent.trigger('mixpanel:track', 'comment_posted', @model)

    _onPressEnter: (ev) ->
      keyCode = ev.keyCode or ev.which
      return ev unless keyCode is 13

      ev.preventDefault()
      @_addComment()
