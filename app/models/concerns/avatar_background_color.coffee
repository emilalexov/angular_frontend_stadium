define ->

  bgColors: ['#f36c60', '#f06292', '#ba68c8', '#9575cd', '#7986cb', '#91a7ff',
             '#4fc3f7', '#4dd0e1', '#4db6ac', '#42bd41', '#aed581', '#dce775',
             '#fff176', '#ffd54f', '#ffb74d', '#ff8a65', '#a1887f', '#e0e0e0',
             '#90a4ae', '#3398db']

  _initBgColor: (idAttribute = 'id') ->
    @listenTo @, "change:#{idAttribute}", ->
      bgColorIndex = @get(idAttribute) % @bgColors.length
      value = @bgColors[bgColorIndex]
      @set('avatar_background_color', value, silent: true)
