define [
  './item_template'
  './option_template'
], (
  itemTemplate
  optionTemplate
) ->

  class AutoCompleteBehavior extends Marionette.Behavior

    key: 'auto_complete'

    ui:
      'autocomplete': '.gc-auto-complete'

    defaults:
      hideSelected: true
      valueField: 'id'
      labelField: 'name'
      sortField: 'sort_id'
      searchField: ['name']
      collection: undefined
      onItemAdd: undefined
      onLoad: undefined
      defaultOption: undefined
      serealizeFn: ->
      render:
        item: (item, escape) ->
          itemTemplate(item)
        option: (item, escape) ->
          optionTemplate(item)

    onShow: ->
      behavior = @
      items = @_prepareItems()
      $select = @ui.autocomplete.selectize
        hideSelected: @options.hideSelected
        valueField: @options.valueField
        labelField: @options.labelField
        sortField: @options.sortField
        searchField: @options.searchField
        options: items
        onItemAdd: (value, $item) ->
          func = behavior.options.onItemAdd
          _.bind(func, behavior.view, value, $item, @)()
          return
        render: @options.render
        dropdownParent: 'body'
      @control = $select[0].selectize

    onDestroy: ->
      @control.destroy()

    _prepareItems: ->
      items = if _.isFunction(@options.collection)
        _.bind(@options.collection, @view)()
      else
        @options.collection

      if items instanceof Backbone.Collection
        items = @_prepareCollection(items)

      @_addDefaultOption(items)

      items

    _prepareCollection: (items) ->
      @collection = items
      @listenTo(@collection, 'reset add remove', @_updateOptionItems)
      @collection.map(@options.serealizeFn)

    _updateOptionItems: ->
      return unless @control
      items = @collection.map(@options.serealizeFn)
      @_addDefaultOption(items)
      @control.clearOptions()
      @control.addOption(items)
      @control.refreshOptions(false)

    _addDefaultOption: (items) ->
      return unless @options.defaultOption
      items.unshift
        id: 0
        name: @options.defaultOption.name || 'CREATE NEW'
        icon: @options.defaultOption.icon || 'gc-icon-exercises-add'
        sort_id: @options.defaultOption.sort_id || '~-1-sort'

