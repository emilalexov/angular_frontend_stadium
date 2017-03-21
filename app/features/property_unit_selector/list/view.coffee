define [
  './item/view'
], (
  ItemView
) ->

  class PropertyUnitSelectorCollectionView extends Marionette.CollectionView

    tagName: 'ul'

    className: 'property-unit-selector bottom'

    childView: ItemView

    childViewOptions: ->
      collectionViewCid: @cid

    childEvents:
      'selected:property_unit': '_propertyUnitSelected'

    _propertyUnitSelected: (childView) ->
      collection = childView.model.collection
      collection.each (model) ->
        return if model is childView.model
        model.set(checked: false)
      @hide()
      @trigger('property_unit:selected', childView.model)

    hide: ->
      @$el.fadeOut(200)

    show: ->
      @$el.fadeIn(200)
