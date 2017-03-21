define [
  './item/view'
], (
  ItemView
) ->

  class View extends Marionette.CollectionView

    className: 'btn-group'

    attributes:
      'data-toggle': 'buttons'

    ui:
      searchScopeRadio: 'input[name=searchScope]'

    events:
      'change @ui.searchScopeRadio': '_setSearchScope'

    childView: ItemView

    _setSearchScope: ->
      q = @model.get('q')
      entityType = @model.get('entity_type')
      searchScope = @$el.find(':checked').val()
      App.vent.trigger 'search:global', q, entityType, searchScope
