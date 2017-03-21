define [
  './template'
], (
  template
) ->
  class AssignedTemplateItemView extends Marionette.ItemView

    template: template

    tagName: 'li'

    className: 'row'

    events:
      'click .gc-exercises-assign-btn-del': '_destroyModel'

    behaviors: ->

      stickit:
        bindings:
          '.name': 'name'
          '.gc-exercises-link-workouts':
            attributes: [
                name: 'href'
                observe: 'name'
                onGet: ->
                  root = _.chain(@model.type).underscore().pluralize().value()
                  "##{root}/#{@model.id}"
            ]
          'span.gc-trainer-list-icon':
            attributes: [
                name: 'class'
                observe: 'name'
                onGet: ->
                  _.chain(@model.type)
                    .humanize()
                    .words()
                    .last()
                    .pluralize()
                    .value()
                    .toLocaleLowerCase()
            ]

    _destroyModel: (ev) ->
      App.request 'modal:confirm',
        title: 'Delete item'
        content: 'Are you sure you want to delete selected item?'
        confirmBtn: 'Delete'
        confirmCallBack: _.bind(@_confirmCallBack, @)

    _confirmCallBack: ->
      @model.destroy(wait: true).then ->
        App.request('messenger:explain', 'item.deleted')
