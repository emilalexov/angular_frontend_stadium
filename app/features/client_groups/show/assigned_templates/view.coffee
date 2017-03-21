define [
  './list/view'
  './template'
], (
  AssignedTemplateListView
  template
) ->

  class AssignedTemplatesLayoutView extends Marionette.LayoutView

    template: template

    className: 'gc-exercises-assign'

    behaviors: ->

      stickit:
        bindings:
          'input.gc-exercises-assign-input':
            attributes: [
                name: 'placeholder'
                observe: 'name'
                onGet: (value) ->
                  name = _.humanize(@options.typeName)
                  "Search through assigned #{name}"
            ]

      regioned:
        views: [
            region: 'list'
            klass: AssignedTemplateListView
            options: ->
              model: @model
              collection: @collection
        ]

      auto_complete:
        onItemAdd: (id, $item, selectize) ->
          App.vent.trigger 'redirect:to', [@options.typeName, id],
            replace: false
          selectize.close()
        collection: =>
          @collection
        serealizeFn: (item) ->
          folder: item.folder?.name
          id: item.get('id')
          name: item.get('name')
          label: item.get('name')
