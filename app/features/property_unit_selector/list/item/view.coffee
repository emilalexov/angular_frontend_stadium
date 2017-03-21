define [
  './template'
], (
  template
) ->

  class PropertyUnitSelectorItemView extends Marionette.ItemView

    template: template

    tagName: 'li'

    behaviors:

      stickit:
        bindings:
          '.name': 'name'
          'label':
            attributes: [
                observe: 'id'
                name: 'for'
                onGet: (value) -> "#{@cid}_#{value}"
            ]
          'input':
            observe: 'checked'
            attributes: [
                observe: 'id'
                name: 'id'
                onGet: (value) -> "#{@cid}_#{value}"
              ,
                observe: 'id'
                name: 'name'
                onGet: -> "#{@options.collectionViewCid}_property_unit"
            ]
          'i':
            attributes: [
                observe: 'checked'
                name: 'class'
                onGet: (value) ->
                  if value then 'fa-check-square' else 'fa-square-o'
            ]

    triggers:
      'change input': 'selected:property_unit'