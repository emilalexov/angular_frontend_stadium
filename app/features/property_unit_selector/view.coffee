define [
  './list/view'
  './template'
], (
  TooltipView
  template
) ->

  class PropertyUnitSelectorView extends Marionette.LayoutView

    template: template

    className: 'gc-gear-wrapper'

    behaviors:

      regioned:
        views: [
            region: 'tooltip'
            klass: TooltipView
            options: ->
              collection: @collection
        ]

    events:
      'click i.fa.fa-cog': 'showTooltip'

    initialize: ->
      @collection.get(@options.selected)?.set(checked: true)
      @listenTo @collection, 'add remove reset', =>
        @_ensureVisibility()
      $(document).on "click.#{@cid} mousedown.#{@cid} tap.#{@cid}", (e) =>
        @_hideTooltip() if !@$el.is(e.target) and @$el.has(e.target).length is 0

    onDestroy: ->
      $(document).off(".#{@cid}")

    onShow: ->
      @listenTo @views.tooltip, 'property_unit:selected', @_propertyUnitSelected
      @_ensureVisibility()

    _propertyUnitSelected: (model) ->
      @trigger('selected', model)

    updateUnits: (models, defaultUnitId) ->
      @collection.reset(models)
      @collection.each (model) ->
        model.set(checked: model.id is defaultUnitId)

    showTooltip: ->
      @views.tooltip.show() unless @collection.isEmpty()

    _hideTooltip: ->
      @views.tooltip?.hide()

    _ensureVisibility: ->
      if @collection.length > 1 then @$el.show() else @$el.hide()
