define [
  './collection'
  './item/view'
], (
  Collection
  BreadcrumbsItemView
) ->

  class BreadcrumbsView extends Marionette.CollectionView

    tagName: 'h2'

    className: 'gc-breadcrumbs-title'

    childView: BreadcrumbsItemView

    childViewOptions: (model, index) ->
      return {isEditable: false} unless @options.editable
      isEditable = @_isEditable(model)
      options =
        isEditable: isEditable
      if isEditable
        options.attributes =
          contenteditable: isEditable
      options

    constructor: ->
      @collection = new Collection
      super

    onShow: ->
      @targetModel = _.result(@options, 'model')
      if _.isUndefined(@targetModel)
        throw new Error('target model should exist')
      @listenTo(@targetModel, 'change:name', @_initBreadcrumbs)
      @_initBreadcrumbs()

    _initBreadcrumbs: ->
      @collection.initFromModel(@targetModel)

    _isEditable: (model) ->
      @collection.indexOf(model) is @collection.length - 1 and
        can('update', _.result(@options, 'model'))
