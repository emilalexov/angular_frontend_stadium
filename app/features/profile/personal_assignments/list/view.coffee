define [
  './item/view'
  './empty/view'
], (
  AssignedTemplateItemView
  EmptyView
) ->

  class AssignedTemplatesListView extends Marionette.CollectionView

    tagName: 'ul'

    className: 'gc-folders-entity-list'

    emptyView: EmptyView

    childView: AssignedTemplateItemView

    viewComparator: (model) ->
      -1 * model.get('id')

    filter: (model, index, collection) ->
      !model.get('is_program_part') and model.get('status') is 'active'

    childViewOptions: ->
      clientGroup: @model
      type: @collection.model.prototype.type

    initialize: (data) ->
      @request = @collection.fetch()

    onBeforeDestroy: ->
      @request?.abort?()
