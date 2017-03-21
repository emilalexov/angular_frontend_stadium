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
      'click a.gc-exercises-assign-btn-del': '_unassign'

    behaviors: ->

      stickit:
        bindings:
          '.name': 'name'
          '.gc-exercises-link-workouts':
            attributes: [
                name: 'href'
                observe: 'name'
                onGet: (_value) ->
                  root = _.chain(@model.type).underscore().pluralize().value()
                  "##{root}/#{@model.id}"
            ]
          'span.gc-trainer-list-icon':
            attributes: [
                name: 'class'
                observe: 'name'
                onGet: (_value) ->
                  _.chain(@model.type)
                    .humanize()
                    .words()
                    .first()
                    .pluralize()
                    .value()
                    .toLocaleLowerCase()
            ]

    _unassign: ->
      @options.clientGroup.unassign(@model)
        .then => @destroy()