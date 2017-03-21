define ->

  class ExercisesConnectorsBehavior extends Marionette.Behavior

    key: 'exercises_connectors'

    colorDefault: '#ababab'

    colors: [
      '#4caf50'
      '#e91e63'
      '#673ab7'
      '#ff9800'
      '#2196f3'
      '#ffeb3b'
      '#00bcd4'
      '#f44336'
      '#009688'
      '#8bc34a'
      '#cddc39'
      '#03a9f4'
      '#ffc107'
      '#3f51b5'
      '#ff5722'
      '#795548'
      '#9c27b0'
      '#607d8b'
    ]

    initialize: ->
      @_debouncedInit = _.debounce(@_init, 300)
      @listenTo(@view, 'show', @_debouncedInit)

    onBeforeShow: ->
      @listenTo(@view.collection, 'reset add remove change', @_debouncedInit)

    _init: ->
      @letterColors = {}
      @lastColor = -1

      @view.collection.each (model, index) =>
        current = model.get('order_letter')
        previous =
          @view.collection.models[index - 1]?.get('order_letter')
        next =
          @view.collection.models[index + 1]?.get('order_letter')

        @_setColor(model, current)
        @_setPosition(model, current, previous, next)

    _setColor: (model, current) ->
      color = if current is '~'
        @colorDefault
      else
        unless @letterColors[current]
          @lastColor = (@lastColor + 1) % @colors.length
          @letterColors[current] = @colors[@lastColor]
        @letterColors[current]

      model.set
        color: color

    _setPosition: (model, current, previous, next) ->
      position =
        if current is '~'
          ''
        else if current is previous
          if current is next
            'middle'
          else
            'last'
        else if current is next
          'first'
        else
          ''

      model.set
        order_position: position
