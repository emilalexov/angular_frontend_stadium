define ->

  class BreadcrumbsItemView extends Marionette.ItemView

    template: -> ''

    tagName: 'span'

    events:
      'keydown': '_onKeyDown'

    behaviors: ->
      stickit:
        bindings:
          ':el':
            observe: 'name'
            events: ['blur']

    modelEvents:
      'change:name': '_saveName'

    initialize: ->
      @oldName = @model.get('name')

    _saveName: ->
      return unless @options.isEditable
      condition = !_.isUndefined(@oldName) &&
        @model.hasChanged('name') &&
        @model.get('name') != @oldName
      if condition
        @model.save()
          .then =>
            @oldName = @model.get('name')
          .fail (_xhr, _textStatus, _errorThrown) =>
            @model.set(name: @oldName)

    _onKeyDown: (ev) ->
      @_preventEnter(ev)

      key = ev.keyCode || ev.which
      currentValue = $(ev.currentTarget).text()

      if key in [8, 46]
        return true
      else if currentValue.length > 64
        ev.preventDefault()
        return false

    _preventEnter: (ev) ->
      if ev.which in [13, 27]
        ev.preventDefault()
        $(ev.currentTarget).blur()
