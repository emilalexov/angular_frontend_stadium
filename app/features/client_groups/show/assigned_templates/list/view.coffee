define [
  './item/view'
], (
  AssignedTemplateItemView
) ->

  class AssignedTemplatesListView extends Marionette.CollectionView

    tagName: 'ul'

    className: 'gc-folders-entity-list'

    childView: AssignedTemplateItemView

    childViewOptions: ->
      clientGroup: @model

    initialize: (data) ->
      @request = @collection.fetch()

    onBeforeDestroy: ->
      @request?.abort?()
