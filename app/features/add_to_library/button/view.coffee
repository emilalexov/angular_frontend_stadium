define ->

  class View extends Marionette.ItemView

    template: ->
      'Add to Library'

    tagName: 'button'

    className: 'btn btn-primary gc-add-to-library-button'

    behaviors:

      stickit:
        bindings:
          ':el':
            observe: ['user_id', 'author_id']
            visible: ->
              can('add_to_library', @model)

    events:
      'click': '_askToAdd'

    _askToAdd: ->
      App.request 'base:addToLibraryModal',
        model: @model

    #_askToRemove: ->
      #App.request('modal:confirm:delete', @model)
