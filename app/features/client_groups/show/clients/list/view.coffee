define [
  './item/view'
], (
  MembersItemView
) ->
  class MembersView extends Marionette.CollectionView

    tagName: 'ul'

    className: 'gc-folders-entity-list'

    childView: MembersItemView

    events:
      'click @ui.rmAssign': 'rmAssign'

    ui:
      rmAssign: '.gc-exercises-assign-btn-del'
      removeModal: '#gc-remove-from-group-modal'

    initialize: ->
      @listenTo(@, 'nav:delete', @showRemoveClient)

    rmAssign: (ev) =>
      assignId = $(ev.currentTarget).data 'id'
      model = @collection.get assignId
      model.destroy()

    showRemoveClient: (ev) =>
      @ui.removeModal.modal 'show'
