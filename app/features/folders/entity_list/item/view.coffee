define [
  './template'
], (
  template
) ->

  class EntityItemView extends Marionette.ItemView

    template: template

    tagName: 'li'

    className: 'row'

    ui:
      checkbox: '.gc-exercises-chb input'

    events:
      'click @ui.checkbox': 'itemChecked'

    behaviors:

      stickit:
        bindings:
          ':el':
            classes:
              'gc-folder':
                observe: 'folder_id'
                onGet: (value) ->
                  !value
              'gc-folder-item':
                observe: 'folder_id'
                onGet: (value) ->
                  !!value
            attributes: [
                observe: 'id'
                name: 'data-id'
              ]
          'input':
            observe: 'folder_id'
            updateModel: false
            attributes: [
                observe: 'id'
                name: 'data-id'
            ]
          '.gc-exercises-folder-icon':
            observe: 'folder_id'
            visible: (value) ->
              !value
          '.gc-exercises-item-icon':
            observe: 'folder_id'
            visible: (value) ->
              !!value
            attributes: [
                name: 'class'
                onGet: (value) ->
                  "gc-exercises-item-icon-#{@type}"
            ]
          '.gc-exercises-link':
            observe: 'name'
            attributes: [
                observe: ['id', 'folder_id']
                name: 'href'
                onGet: (values) ->
                  if values[1]
                    "##{@type}/#{values[0]}"
                  else
                    "##{@type}_folder/#{values[0]}"
              ,
                observe: ['id']
                name: 'data-key'
            ]
          '.gc-exercises-update-time':
            observe: 'updated_at'
            onGet: (value) ->
              moment.h.ago(value)
            attributes: [
              name: 'title'
              observe: 'updated_at'
              onGet: (value) ->
                moment.h.full(value)
            ]

    initialize: (options) =>
      @type = options.type

    itemChecked: (ev) =>
      @trigger 'item:clicked'
