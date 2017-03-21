define [
  './item/view'
], (
  ScheduledWorkoutSliderItemView
) ->

  class ScheduledWorkoutSliderView extends Marionette.CollectionView

    className: 'owl-carousel owl-theme'

    attributes:
      id: 'workout-calendar'

    childView: ScheduledWorkoutSliderItemView

    childEvents:
      'owl:prev': '_onOwlPrev'
      'owl:next': '_onOwlNext'

    initialize: ->
      @listenTo(@collection, 'sync', @onCollectionSync)

    onCollectionSync: ->
      @$el.owlCarousel
        navigation: false
        slideSpeed: 250
        paginationSpeed: 250
        singleItem: true
      @owlCarousel = @$el.data('owlCarousel')

    onDestroy: ->
      @owlCarousel.destroy()

    _onOwlPrev: ->
      @owlCarousel.prev()

    _onOwlNext: ->
      @owlCarousel.next()
